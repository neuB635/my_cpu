`include "lib/defines.vh"
module ID(
    //这个覆盖了书中ID段和ID/EX段

    input wire clk,
    input wire rst,
    // input wire flush,
    input wire [`StallBus-1:0] stall,
    
    output wire stallreq,

    input wire [`IF_TO_ID_WD-1:0] if_to_id_bus,

    input wire [31:0] inst_sram_rdata,

    input wire [`WB_TO_RF_WD-1:0] wb_to_rf_bus,

    input wire [`WB_TO_RF_WD-1:0] ex_to_rf_bus,//Siri

    input wire [`WB_TO_RF_WD-1:0] mem_to_rf_bus,//Siri


    output wire [`ID_TO_EX_WD-1:0] id_to_ex_bus,

    output wire [`BR_WD-1:0] br_bus,

    //Siri
    input wire is_in_delayslot_i,
    output wire is_in_delayslot_o,
    output wire next_inst_in_delayslot_o


);
    
    //Siri
    //读入mem的返回值
    wire mem_to_rf_we;
    wire [4:0] mem_to_rf_waddr;
    wire [31:0] mem_to_rf_wdata;
    assign {
        mem_to_rf_we,
        mem_to_rf_waddr,
        mem_to_rf_wdata
    }=mem_to_rf_bus;
    //Siri

    //Siri
    //读入ex的返回值
    wire ex_to_rf_we;
    wire [4:0] ex_to_rf_waddr;
    wire [31:0] ex_to_rf_wdata;

    assign{
        ex_to_rf_we,
        ex_to_rf_waddr,
        ex_to_rf_wdata
    }=ex_to_rf_bus;
    //Siri





    reg [`IF_TO_ID_WD-1:0] if_to_id_bus_r;
    wire [31:0] inst;
    wire [31:0] id_pc;
    wire ce;

    wire wb_rf_we;
    wire [4:0] wb_rf_waddr;
    wire [31:0] wb_rf_wdata;

    always @ (posedge clk) begin
        if (rst) begin
            if_to_id_bus_r <= `IF_TO_ID_WD'b0;        
        end
        
        // else if (flush) begin
        //     ic_to_id_bus <= `IC_TO_ID_WD'b0;
        // end
        
        else if (stall[1]==`Stop && stall[2]==`NoStop) begin
            if_to_id_bus_r <= `IF_TO_ID_WD'b0;
        end
        else if (stall[1]==`NoStop) begin
            if_to_id_bus_r <= if_to_id_bus;
        end else begin
            
        end
    end
    

    
    assign inst = inst_sram_rdata;
    assign {
        ce,
        id_pc
    } = if_to_id_bus_r;
    assign {
        wb_rf_we,
        wb_rf_waddr,
        wb_rf_wdata
    } = wb_to_rf_bus;

    wire [5:0] opcode;
    wire [4:0] rs,rt,rd,sa;
    wire [5:0] func;
    wire [15:0] imm;
    wire [25:0] instr_index;
    wire [19:0] code;
    wire [4:0] base;
    wire [15:0] offset;
    wire [2:0] sel;

    wire [63:0] op_d, func_d;
    wire [31:0] rs_d, rt_d, rd_d, sa_d;

    wire [2:0] sel_alu_src1;
    wire [3:0] sel_alu_src2;
    wire [11:0] alu_op;

    wire data_ram_en;
    wire [3:0] data_ram_wen;
    
    wire rf_we;
    wire [4:0] rf_waddr;
    wire sel_rf_res;
    wire [2:0] sel_rf_dst;

    wire [31:0] rdata1, rdata2;
    wire [31:0] rdata1_1, rdata2_1;
    wire [31:0] rdata1_2, rdata2_2;
   

    assign opcode = inst[31:26];
    assign rs = inst[25:21];//reg1_addr_o
    assign rt = inst[20:16];//reg2_addr_o
    assign rd = inst[15:11];
    assign sa = inst[10:6];
    assign func = inst[5:0];
    assign imm = inst[15:0];
    assign instr_index = inst[25:0];
    assign code = inst[25:6];
    assign base = inst[25:21];
    assign offset = inst[15:0];
    assign sel = inst[2:0];

    regfile u_regfile(
    	.clk    (clk    ),
        .raddr1 (rs ),
        .rdata1 (rdata1_1 ),
        .raddr2 (rt ),
        .rdata2 (rdata2_1 ),
        .we     (wb_rf_we     ),
        .waddr  (wb_rf_waddr  ),
        .wdata  (wb_rf_wdata  )
    ); 
     
    assign rdata1 = (ce == 1'b0) ? 32'b0 : ((ex_to_rf_we == 1'b1 ) && (ex_to_rf_waddr==rs)) ? 
                        ex_to_rf_wdata :((mem_to_rf_we == 1'b1) && (mem_to_rf_waddr==rs))? mem_to_rf_wdata : rdata1_1 ;
    assign rdata2 = (ce == 1'b0) ? 32'b0 : ((ex_to_rf_we == 1'b1 ) && (ex_to_rf_waddr==rt)) ? 
                        ex_to_rf_wdata :((mem_to_rf_we == 1'b1) && (mem_to_rf_waddr==rt))? mem_to_rf_wdata : rdata2_1 ;
    
    
    
    
    //Siri
    wire inst_ori, inst_lui, inst_addiu, inst_beq;
    wire inst_add,inst_addi,inst_addu;
    wire inst_sub,inst_subu;
    wire inst_slt,inst_slti,inst_sltu,inst_sltiu;
    //乘除
    wire inst_and,inst_andi,inst_nor,inst_or,inst_xor,inst_xori;//

    //移位
    wire inst_sllv,inst_sll;//逻辑左移
    wire inst_srav,inst_sra;//算术右移
    wire inst_srlv,inst_srl;//逻辑右移

    //分支跳转
    wire inst_bne;//不等跳转
    wire inst_bgez,inst_bgtz;//大于（&？等于）0跳转
    wire inst_blez,inst_bltz;//小于（&？等于）0跳转
    wire inst_bgezal;//大于等于0跳转，并保存pc值至通用寄存器
    wire inst_bltzal;//小于0跳转，并保存pc值至通用寄存器

    wire inst_j,inst_jal,inst_jr,inst_jalr;//无条件跳转

    //数据移动
    wire inst_mfhi,inst_mflo,inst_mthi,inst_mtlo;

    //自陷指令
    wire inst_break,inst_syscall;

    //访存指令
    wire inst_lb,inst_lbu;
    wire inst_lh,inst_lhu;
    wire inst_lw;
    wire inst_sb,inst_sh,inst_sw;

    //特权指令
    wire inst_eret;
    wire inst_mfc0;
    wire inst_mtc0;
    //


    wire op_add, op_sub, op_slt, op_sltu;
    wire op_and, op_nor, op_or, op_xor;
    wire op_sll, op_srl, op_sra, op_lui;


    decoder_6_64 u0_decoder_6_64(
    	.in  (opcode  ),
        .out (op_d )
    );

    decoder_6_64 u1_decoder_6_64(
    	.in  (func  ),
        .out (func_d )
    );
    
    decoder_5_32 u0_decoder_5_32(
    	.in  (rs  ),
        .out (rs_d )
    );

    decoder_5_32 u1_decoder_5_32(
    	.in  (rt  ),
        .out (rt_d )
    );

    
    assign inst_add     = op_d[6'b00_0000]&func_d[6'b10_0000];
    assign inst_addi    = op_d[6'b00_1000];
    assign inst_addu    = op_d[6'b00_0000]&func_d[6'b10_0001];
    assign inst_addiu   = op_d[6'b00_1001];

    assign inst_sub     = op_d[6'b00_0000]&func_d[6'b10_0010];
    assign inst_subu    = op_d[6'b00_0000]&func_d[6'b10_0011];
    
    assign inst_slt     = op_d[6'b00_0000]&func_d[6'b10_1010];
    assign inst_slti    = op_d[6'b00_1010];
    assign inst_sltu    = op_d[6'b00_0000]&func_d[6'b10_1011];
    assign inst_sltiu   = op_d[6'b00_1011];

    //乘除

    assign inst_and     = op_d[6'b00_0000]&func_d[6'b10_0100];
    assign inst_andi    = op_d[6'b00_1100];
    assign inst_lui     = op_d[6'b00_1111];
    assign inst_nor     = op_d[6'b00_0000]&func_d[6'b10_0111];
    assign inst_or      = op_d[6'b00_0000]&func_d[6'b10_0101];
    assign inst_ori     = op_d[6'b00_1101];
    assign inst_xor     = op_d[6'b00_0000]&func_d[6'b10_0110];
    assign inst_xori    = op_d[6'b00_1110];

    assign inst_sllv    = op_d[6'b00_0000]&func_d[6'b00_0100];
    assign inst_sll     = op_d[6'b00_0000]&func_d[6'b00_0000];

    assign inst_srav    = op_d[6'b00_0000]&func_d[6'b00_0111];
    assign inst_sra     = op_d[6'b00_0000]&func_d[6'b00_0011];

    assign inst_srlv    = op_d[6'b00_0000]&func_d[6'b00_0110];
    assign inst_srl     = op_d[6'b00_0000]&func_d[6'b00_0010];

    assign inst_beq     = op_d[6'b00_0100];
    assign inst_bne     = op_d[6'b00_0101];
    assign inst_bgez    = op_d[6'b00_0001]&rt_d[5'b0_0001];
    assign inst_bgtz    = op_d[6'b00_0111];
    assign inst_blez    = op_d[6'b00_0110];
    assign inst_bltz    = op_d[6'b00_0001]&rt_d[5'b0_0000];
    assign inst_bgezal  = op_d[6'b00_0001]&rt_d[5'b1_0001];
    assign inst_bltzal  = op_d[6'b00_0001]&rt_d[5'b1_0000];
    assign inst_j       = op_d[6'b00_0010];
    assign inst_jal     = op_d[6'b00_0011];
    assign inst_jr      = op_d[6'b00_0000]&func_d[6'b00_1000];
    assign inst_jalr    = op_d[6'b00_0000]&func_d[6'b00_1001];

    assign inst_mfhi    = op_d[6'b00_0000]&func_d[6'b01_0000];
    assign inst_mflo    = op_d[6'b00_0000]&func_d[6'b01_0010];
    assign inst_mthi    = op_d[6'b00_0000]&func_d[6'b01_0010];
    assign inst_mthi    = op_d[6'b00_0000]&func_d[6'b01_0001];
    assign inst_mtlo    = op_d[6'b00_0000]&func_d[6'b01_0011];

    assign inst_break   = op_d[6'b00_0000]&func_d[6'b00_1101];
    assign inst_syscall = op_d[6'b00_0000]&func_d[6'b00_1100];

    assign inst_lb      = op_d[6'b10_0000];
    assign inst_lbu     = op_d[6'b10_0100];
    assign inst_lh      = op_d[6'b10_0001];
    assign inst_lhu     = op_d[6'b10_0101];
    assign inst_lw      = op_d[6'b10_0011];
    assign inst_sb      = op_d[6'b10_1000];
    assign inst_sh      = op_d[6'b10_1001];
    assign inst_sw      = op_d[6'b10_1011];

    assign inst_eret    = op_d[6'b01_0000]&inst[25];
    assign inst_mfc0    = op_d[6'b01_0000]&rs_d[5'b0_0000];
    assign inst_mtc0    = op_d[6'b01_0000]&rs_d[5'b0_0100];
    //Siri

    assign id_pc_plus8 = id_pc+32'h8;
    wire  [31:0] idc1;
    wire [31:0] idc2;
    // regfile u1_regfile(
    // 	.clk    (clk    ),
    //     .raddr1 (5'b0 ),
    //     .rdata1 ( idc1),
    //     .raddr2 (5'b0 ),
    //     .rdata2 (idc2 ),
    //     .we     (1'b0     ),
    //     .waddr  (5'b11111  ),
    //     .wdata  (id_pc_plus8  )
    // );  

    // rs to reg1
    assign sel_alu_src1[0] = inst_add|inst_addi|inst_addu|inst_addiu|
                             inst_sub|inst_subu|
                             inst_slt|inst_slti|inst_sltu|inst_sltiu|
                             inst_and|inst_andi|inst_nor|inst_or|inst_ori|inst_xor|inst_xori|
                             inst_sllv|inst_srav|inst_srlv|
                             inst_jr;//除了第一行都是新加的

    // pc to reg1
    assign sel_alu_src1[1] = inst_jal;
    

    // sa_zero_extend to reg1
    assign sel_alu_src1[2] = 1'b0;
   
    
    // rt to reg2
    assign sel_alu_src2[0] = inst_add|inst_addi|inst_addu|
                             inst_sub|inst_subu|
                             inst_slt|inst_sltu|inst_sltiu|
                             inst_and|inst_nor|inst_or|inst_xor;
    
    // imm_sign_extend to reg2
    assign sel_alu_src2[1] = inst_lui | inst_addiu|
                             inst_addi|
                             inst_slti|inst_sltiu;
    
    

    // 32'h8 to reg2
    assign sel_alu_src2[2] = inst_jal;
    

    // imm_zero_extend to reg2
    assign sel_alu_src2[3] = inst_ori|inst_andi|inst_xori;



    assign op_add = inst_addiu|inst_add|inst_addi|inst_addu
                    |inst_jal;
    assign op_sub = inst_sub|inst_subu;
    assign op_slt = inst_slt|inst_slti;
    assign op_sltu = inst_sltiu|inst_sltu;
    assign op_and = inst_and|inst_andi;
    assign op_nor = inst_nor;//或非
    assign op_or = inst_ori|inst_or;//或
    assign op_xor = inst_xor|inst_xori;//异或
    assign op_sll = inst_sll|inst_sllv;
    assign op_srl = inst_srl|inst_srlv;
    assign op_sra = inst_sra|inst_srav;
    assign op_lui = inst_lui;

    assign alu_op = {op_add, op_sub, op_slt, op_sltu,
                     op_and, op_nor, op_or, op_xor,
                     op_sll, op_srl, op_sra, op_lui};



    // load and store enable
    assign data_ram_en = 1'b0;

    // write enable
    assign data_ram_wen = 4'b0;



    // regfile store enable
    assign rf_we = inst_ori | inst_lui | inst_addiu | inst_subu|inst_jal|inst_addu|inst_sll;



    // store in [rd]
    assign sel_rf_dst[0] = inst_add|inst_addu|
                           inst_sub|inst_subu|
                           inst_slt|inst_sltu|
                           inst_and|inst_nor|inst_or|inst_xor;
    // store in [rt] 
    assign sel_rf_dst[1] = inst_ori | inst_lui | inst_addiu|
                           inst_slti|inst_sltiu|inst_andi|inst_ori|inst_xori;
    // store in [31]
    assign sel_rf_dst[2] = inst_jal;

    // sel for regfile address
    assign rf_waddr = {5{sel_rf_dst[0]}} & rd 
                    | {5{sel_rf_dst[1]}} & rt
                    | {5{sel_rf_dst[2]}} & 32'd31;

    // 0 from alu_res ; 1 from ld_res
    assign sel_rf_res = 1'b0; 

    assign id_to_ex_bus = {
        id_pc,          // 158:127
        inst,           // 126:95
        alu_op,         // 94:83
        sel_alu_src1,   // 82:80
        sel_alu_src2,   // 79:76
        data_ram_en,    // 75
        data_ram_wen,   // 74:71
        rf_we,          // 70
        rf_waddr,       // 69:65
        sel_rf_res,     // 64
        rdata1,         // 63:32
        rdata2          // 31:0
    };

    wire br_e;
    wire [31:0] br_addr;
    wire rs_eq_rt;
    wire rs_ge_z;
    wire rs_gt_z;
    wire rs_le_z;
    wire rs_lt_z;
    wire [31:0] pc_plus_4;
    assign pc_plus_4 = id_pc + 32'h4;

    assign rs_eq_rt = (rdata1 == rdata2);
    assign rs_ge_z  = (rdata1 >= 0);
    assign rs_gt_z  = (rdata1 >  0);
    assign rs_le_z  = (rdata1 <= 0);
    assign rs_lt_z  = (rdata1 <  0);

    assign br_e = inst_beq & rs_eq_rt|
                  inst_bne & !rs_eq_rt|
                  (inst_bgez|inst_bgezal) & rs_ge_z|
                  inst_bgtz & rs_gt_z|
                  inst_blez & rs_le_z|
                  (inst_bltz|inst_bltzal) & rs_lt_z|
                  inst_j|inst_jal|inst_jr|inst_jalr;
    assign br_addr = inst_beq|inst_bne|inst_bgez|inst_bgtz|inst_blez|inst_bltz|inst_bgezal|inst_bltzal ?
                     (pc_plus_4 + {{14{inst[15]}},inst[15:0],2'b0}) : 
                     inst_j|inst_jal ?
                     {pc_plus_4[31:28],instr_index,2'b0} :
                     inst_jr|inst_jalr ?
                     rdata1 :
                     32'b0;
    assign br_bus = {
        br_e,//是否执行相等的跳转
        br_addr//跳转位置
    };
    

endmodule