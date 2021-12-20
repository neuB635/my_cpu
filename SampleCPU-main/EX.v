`include "lib/defines.vh"
module EX(
    input wire clk,//传入时钟周期
    input wire rst,//复位信号，负责初始化各项数据
    input wire [`StallBus-1:0] stall,//停止信号，负责暂停流水线
    input wire [`ID_TO_EX_WD-1:0] id_to_ex_bus,//ID段到EX段的总线
    output wire [`EX_TO_MEM_WD-1:0] ex_to_mem_bus,//EX段到MEM段的总线
    output wire data_sram_en,//是否对内存有操作
    output wire [3:0] data_sram_wen,//写入内存的使能
    output wire [31:0] data_sram_addr,//写入的内存的地址
    output wire [31:0] data_sram_wdata,//写入内存的数据
    output wire [`EX_TO_RF_BUS-1:0] ex_to_rf_bus,//EX段到ID段的总线
    output wire stallreq_for_ex // 判断是否需要暂停（乘法，除法）
    // input wire flush,
);

    reg [`ID_TO_EX_WD-1:0] id_to_ex_bus_r;

    always @ (posedge clk) begin
        if (rst) begin
            id_to_ex_bus_r <= `ID_TO_EX_WD'b0;
        end
        // else if (flush) begin
        //     id_to_ex_bus_r <= `ID_TO_EX_WD'b0;
        // end
        else if (stall[2]==`Stop && stall[3]==`NoStop) begin
            id_to_ex_bus_r <= `ID_TO_EX_WD'b0;
        end
        else if (stall[2]==`NoStop) begin
            id_to_ex_bus_r <= id_to_ex_bus;
        end
    end

    wire [31:0] ex_pc, inst;
    wire [11:0] alu_op;
    wire [2:0] sel_alu_src1;
    wire [3:0] sel_alu_src2;
    //wire data_ram_en;
    //wire [3:0] data_ram_wen;
    wire rf_we;
    wire [4:0] rf_waddr;
    wire sel_rf_res;
    wire [31:0] rf_rdata1, rf_rdata2;
    wire [1:0] hilo_read;
    wire hilo_we;
    wire [1:0] hilo_write;
    wire stop_div_mul;
    wire signed_mul_i;
    wire [1:0]div_divu;
    wire [1:0]sb_sh_en;
    wire [1:0]mul_mulu;
    //reg is_in_delayslot;
    wire [3:0]new_data_sram_wen;
    wire [3:0]lb_lh_lw;
    assign {
        mul_mulu,
        lb_lh_lw,
        signed_mul_i,
        stop_div_mul,
        div_divu,       //166:165
        // signed_div_i,
        hilo_write,
        hilo_we,
        hilo_read,      
        ex_pc,          // 148:117
        inst,           // 116:85
        alu_op,         // 84:83
        sel_alu_src1,   // 82:80
        sel_alu_src2,   // 79:76
        data_sram_en,    // 75
        new_data_sram_wen,   // 74:71
        rf_we,          // 70
        rf_waddr,       // 69:65
        sel_rf_res,     // 64
        rf_rdata1,         // 63:32
        rf_rdata2          // 31:0
    } = id_to_ex_bus_r;

    //load store相关
    wire [5:0] ld_st_op;
    assign ld_st_op=data_sram_en?inst[31:26]: 6'b00_0000;
    assign data_sram_addr=data_sram_en?rf_rdata1+{{16{inst[15]}},inst[15:0]}:32'b0;
    assign data_sram_wen=    (new_data_sram_wen == 4'b1111)?4'b1111:
                             ((new_data_sram_wen == 4'b0011)&(data_sram_addr[1:0]==2'b00))?4'b0011:
                             ((new_data_sram_wen == 4'b0011)&(data_sram_addr[1:0]==2'b10))?4'b1100:
                             ((new_data_sram_wen == 4'b0001)&(data_sram_addr[1:0]==2'b00))?4'b0001:
                             ((new_data_sram_wen == 4'b0001)&(data_sram_addr[1:0]==2'b01))?4'b0010:
                             ((new_data_sram_wen == 4'b0001)&(data_sram_addr[1:0]==2'b10))?4'b0100:
                             ((new_data_sram_wen == 4'b0001)&(data_sram_addr[1:0]==2'b11))?4'b1000:4'b0;

    assign data_sram_wdata=(data_sram_wen == 4'b1111)?rf_rdata2:
                           (data_sram_wen == 4'b0011)?{16'b0,rf_rdata2[15:0]}:
                           (data_sram_wen == 4'b1100)?{rf_rdata2[15:0],16'b0}:
                           (data_sram_wen == 4'b1000)?{rf_rdata2[7:0],24'b0}:
                           (data_sram_wen == 4'b0100)?{8'b0,rf_rdata2[7:0],16'b0}:
                           (data_sram_wen == 4'b0010)?{16'b0,rf_rdata2[7:0],8'b0}:
                           (data_sram_wen == 4'b0001)?{24'b0,rf_rdata2[7:0]}:32'b0;
    
    


    // {
    //                            new_data_sram_wen[3]?rf_rdata2[31:24]:8'b0,
    //                            new_data_sram_wen[2]?rf_rdata2[23:16]:8'b0,
    //                            new_data_sram_wen[1]?rf_rdata2[15:8]:8'b0,
    //                            new_data_sram_wen[0]?rf_rdata2[7:0]:8'b0
    //                        };

    wire [4:0] new_lb_lw_lh;
    assign new_lb_lw_lh =    ( lb_lh_lw == 4'b1111)?5'b1_1111:
                             ((lb_lh_lw == 4'b0011)&(data_sram_addr[1:0]==2'b00))?5'b1_1100:
                             ((lb_lh_lw == 4'b0011)&(data_sram_addr[1:0]==2'b10))?5'b1_0011:
                             ((lb_lh_lw == 4'b0001)&(data_sram_addr[1:0]==2'b00))?5'b1_1000:
                             ((lb_lh_lw == 4'b0001)&(data_sram_addr[1:0]==2'b01))?5'b1_0100:
                             ((lb_lh_lw == 4'b0001)&(data_sram_addr[1:0]==2'b10))?5'b1_0010:
                             ((lb_lh_lw == 4'b0001)&(data_sram_addr[1:0]==2'b11))?5'b1_0001:
                             ((lb_lh_lw == 4'b0111)&(data_sram_addr[1:0]==2'b00))?5'b0_1100:
                             ((lb_lh_lw == 4'b0111)&(data_sram_addr[1:0]==2'b10))?5'b0_0011:
                             ((lb_lh_lw == 4'b0101)&(data_sram_addr[1:0]==2'b00))?5'b0_1000:
                             ((lb_lh_lw == 4'b0101)&(data_sram_addr[1:0]==2'b01))?5'b0_0100:
                             ((lb_lh_lw == 4'b0101)&(data_sram_addr[1:0]==2'b10))?5'b0_0010:
                             ((lb_lh_lw == 4'b0101)&(data_sram_addr[1:0]==2'b11))?5'b0_0001:5'b0_0000;

     



    wire [31:0] imm_sign_extend, imm_zero_extend, sa_zero_extend;
    assign imm_sign_extend = {{16{inst[15]}},inst[15:0]};
    assign imm_zero_extend = {16'b0, inst[15:0]};
    assign sa_zero_extend = {27'b0,inst[10:6]};

    //数据移动指令相关
    
    

    wire [31:0] alu_src1, alu_src2;
    wire [31:0] alu_result, ex_result;
    wire [2:0] lsa_data;
    assign lsa_data = inst[7:6] + 1'b1;

   

    assign alu_src1 = sel_alu_src1[1] ? ex_pc :
                      sel_alu_src1[2] ? sa_zero_extend : 
                      (inst[31:26] == 6'b011100)? rf_rdata1 << lsa_data :rf_rdata1;

    assign alu_src2 = sel_alu_src2[1] ? imm_sign_extend :
                      sel_alu_src2[2] ? 32'h8 :
                      sel_alu_src2[3] ? imm_zero_extend : rf_rdata2;
    
    alu u_alu(
    	.alu_control (alu_op ), // 进行哪种运算
        .alu_src1    (alu_src1    ),// 第一个操作数
        .alu_src2    (alu_src2    ),// 第二个操作数
        .alu_result  (alu_result  ) // 计算结果
    );
///////
    wire [63:0]hilo_data;
    wire [31:0]hi;
    wire [31:0]lo;



   

    
    

     // MUL part
    wire [63:0] mul_result;
    wire mul_signed; // 有符号乘法标记
    wire inst_mul, inst_mulu;
    assign {inst_mul,inst_mulu} = mul_mulu;
    assign mul_signed = signed_mul_i;
    wire mul_ready_i;
    reg mul_start_o;
    reg [31:0] mul_opdata1_o;
    reg [31:0] mul_opdata2_o;
    reg signed_mul_o;
     reg stallreq_for_mul;
    mul u_mul(
    	.clk        (clk            ), //时钟
        .resetn     (~rst           ), //复位信号
        .mul_signed (signed_mul_o     ),//是否是有符号的乘法
        .ina        (mul_opdata1_o      ), // 乘法源操作数1
        .inb        (mul_opdata2_o      ), // 乘法源操作数2
        .start_i    (mul_start_o  ),//乘法开始信号
        .ready_o    (mul_ready_i    ),//乘法结束信号
        .result     (mul_result     ) // 乘法结果 64bit
    );
    always @ (*) begin
        if (rst) begin
            stallreq_for_mul = `NoStop;
            mul_opdata1_o = `ZeroWord;
            mul_opdata2_o = `ZeroWord;
            mul_start_o = `DivStop;
            signed_mul_o = 1'b0;
        end
        else begin
            stallreq_for_mul = `NoStop;
            mul_opdata1_o = `ZeroWord;
            mul_opdata2_o = `ZeroWord;
            mul_start_o = `DivStop;
            signed_mul_o = 1'b0;
            case ({inst_mul,inst_mulu})
                2'b10:begin
                    if (mul_ready_i == `DivResultNotReady) begin
                        mul_opdata1_o = rf_rdata1;
                        mul_opdata2_o = rf_rdata2;
                        mul_start_o = `DivStart;
                        signed_mul_o = 1'b1;
                        stallreq_for_mul = `Stop;
                    end
                    else if (mul_ready_i == `DivResultReady) begin
                        mul_opdata1_o = rf_rdata1;
                        mul_opdata2_o = rf_rdata2;
                        mul_start_o = `DivStop;
                        signed_mul_o = 1'b1;
                        stallreq_for_mul = `NoStop;
                    end
                    else begin
                        mul_opdata1_o = `ZeroWord;
                        mul_opdata2_o = `ZeroWord;
                        mul_start_o = `DivStop;
                        signed_mul_o = 1'b0;
                        stallreq_for_mul = `NoStop;
                    end
                end
                2'b01:begin
                    if (mul_ready_i == `DivResultNotReady) begin
                        mul_opdata1_o = rf_rdata1;
                        mul_opdata2_o = rf_rdata2;
                        mul_start_o = `DivStart;
                        signed_mul_o = 1'b0;
                        stallreq_for_mul = `Stop;
                    end
                    else if (mul_ready_i == `DivResultReady) begin
                        mul_opdata1_o = rf_rdata1;
                        mul_opdata2_o = rf_rdata2;
                        mul_start_o = `DivStop;
                        signed_mul_o = 1'b0;
                        stallreq_for_mul = `NoStop;
                    end
                    else begin
                        mul_opdata1_o = `ZeroWord;
                        mul_opdata2_o = `ZeroWord;
                        mul_start_o = `DivStop;
                        signed_mul_o = 1'b0;
                        stallreq_for_mul = `NoStop;
                    end
                end
                default:begin
                end
            endcase
        end
    end














    // DIV part
    wire [63:0] div_result;
    wire inst_div, inst_divu;
    wire div_ready_i;
    ///
    assign {inst_div,inst_divu} = div_divu;
    ///
    reg stallreq_for_div;
    assign stallreq_for_ex = stallreq_for_div|stallreq_for_mul;

    reg [31:0] div_opdata1_o;
    reg [31:0] div_opdata2_o;
    reg div_start_o;
    reg signed_div_o;
   div u_div(
    	.rst          (rst          ),//复位
        .clk          (clk          ),//时钟
        .signed_div_i (signed_div_o ),//是否为有符号除法运算
        .opdata1_i    (div_opdata1_o    ),//被除数
        .opdata2_i    (div_opdata2_o    ),//除数
        .start_i      (div_start_o      ),//是否开始除法运算
        .annul_i      (1'b0      ),//是否取消除法运算
        .result_o     (div_result     ), // 除法结果 64bit
        .ready_o      (div_ready_i      )//除法运算是否结束
    );

    always @ (*) begin
        if (rst) begin
            stallreq_for_div = `NoStop;
            div_opdata1_o = `ZeroWord;
            div_opdata2_o = `ZeroWord;
            div_start_o = `DivStop;
            signed_div_o = 1'b0;
        end
        else begin
            stallreq_for_div = `NoStop;
            div_opdata1_o = `ZeroWord;
            div_opdata2_o = `ZeroWord;
            div_start_o = `DivStop;
            signed_div_o = 1'b0;
            case ({inst_div,inst_divu})
                2'b10:begin
                    if (div_ready_i == `DivResultNotReady) begin
                        div_opdata1_o = rf_rdata1;
                        div_opdata2_o = rf_rdata2;
                        div_start_o = `DivStart;
                        signed_div_o = 1'b1;
                        stallreq_for_div = `Stop;
                    end
                    else if (div_ready_i == `DivResultReady) begin
                        div_opdata1_o = rf_rdata1;
                        div_opdata2_o = rf_rdata2;
                        div_start_o = `DivStop;
                        signed_div_o = 1'b1;
                        stallreq_for_div = `NoStop;
                    end
                    else begin
                        div_opdata1_o = `ZeroWord;
                        div_opdata2_o = `ZeroWord;
                        div_start_o = `DivStop;
                        signed_div_o = 1'b0;
                        stallreq_for_div = `NoStop;
                    end
                end
                2'b01:begin
                    if (div_ready_i == `DivResultNotReady) begin
                        div_opdata1_o = rf_rdata1;
                        div_opdata2_o = rf_rdata2;
                        div_start_o = `DivStart;
                        signed_div_o = 1'b0;
                        stallreq_for_div = `Stop;
                    end
                    else if (div_ready_i == `DivResultReady) begin
                        div_opdata1_o = rf_rdata1;
                        div_opdata2_o = rf_rdata2;
                        div_start_o = `DivStop;
                        signed_div_o = 1'b0;
                        stallreq_for_div = `NoStop;
                    end
                    else begin
                        div_opdata1_o = `ZeroWord;
                        div_opdata2_o = `ZeroWord;
                        div_start_o = `DivStop;
                        signed_div_o = 1'b0;
                        stallreq_for_div = `NoStop;
                    end
                end
                default:begin
                end
            endcase
        end
    end




    ////////

    assign hilo_data =  (hilo_we & (inst[5:1]==5'b01101))? div_result:
                        (hilo_we & (inst[5:1]==5'b01100))? mul_result:
                        hilo_write[0]? {32'b0,rf_rdata1}:
                        hilo_write[1]? {rf_rdata1,32'b0} : 64'b0 ;

    hilo u_hilo(
    	.clk        (clk            ),//传入时钟周期
        .rst        (rst            ),//复位信号，负责初始化各项数据
        .we         (hilo_we        ),//是否写入hilo寄存器
        .hilo_data  (hilo_data      ),//写入hilo寄存器的地址
        .hi         (hi             ),//写入hi寄存器的数据
        .lo         (lo             ) //写入lo寄存器的数据
    ); 
    ///////
    assign ex_result = data_sram_en ?data_sram_wdata: hilo_read[1]?hi: hilo_read[0]?lo:alu_result;

    assign ex_to_mem_bus = {
        new_lb_lw_lh,    //86:82
        ld_st_op,       // 81:76
        ex_pc,          // 75:44
        data_sram_en,    // 43
        data_sram_wen,   // 42:39
        sel_rf_res,     // 38
        rf_we,          // 37
        rf_waddr,       // 36:32
        ex_result       // 31:0
    };

    //Siri
    wire ex_to_rf_we;
    wire [4:0] ex_to_rf_waddr;
    wire [31:0] ex_to_rf_wdata;
    assign ex_to_rf_we =rf_we;
    assign ex_to_rf_waddr=rf_waddr;
    assign ex_to_rf_wdata=ex_result;
    assign ex_to_rf_bus={
        ld_st_op,
        ex_to_rf_we,
        ex_to_rf_waddr,
        ex_to_rf_wdata
    };
    //Siri
   
    
    
endmodule