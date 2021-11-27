`include "lib/defines.vh"
module ID(
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

    output wire [`BR_WD-1:0] br_bus


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


    //Siri
    //如何确定判断的条件
    // wire check_rf_we;
    // wire [4:0] check_rf_waddr;
    // assign check_rf_waddr = ex_to_rf_waddr==rt?ex_to_rf_waddr:mem_to_rf_waddr==rt?mem_to_rf_waddr:wb_rf_waddr==rt?wb_rf_waddr:5'b0;
    // assign check_rf_we=ex_to_rf_waddr==rt?ex_to_rf_we:mem_to_rf_waddr==rt?mem_to_rf_we:wb_rf_waddr==rt?wb_rf_we:1'b0;
    // assign check_rf_we=ex_to_rf_waddr==rt?ex_to_rf_wdata:mem_to_rf_waddr==rt?mem_to_rf_wdata:wb_rf_waddr==rt?wb_rf_wdata:32'b0;
    //Siri

    //这是原来的代码，注释掉了
    regfile u_regfile(
    	.clk    (clk    ),
        .raddr1 (rs ),
        .rdata1 (rdata1 ),
        .raddr2 (rt ),
        .rdata2 (rdata2 ),
        .we     (wb_rf_we     ),
        .waddr  (wb_rf_waddr  ),
        .wdata  (wb_rf_wdata  )
    );




    assign opcode = inst[31:26];
    assign rs = inst[25:21];
    assign rt = inst[20:16];
    assign rd = inst[15:11];
    assign sa = inst[10:6];
    assign func = inst[5:0];
    assign imm = inst[15:0];
    assign instr_index = inst[25:0];
    assign code = inst[25:6];
    assign base = inst[25:21];
    assign offset = inst[15:0];
    assign sel = inst[2:0];

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

    // rs to reg1
    assign sel_alu_src1[0] = inst_add|inst_addi|inst_addu|inst_addiu|
                             inst_sub|inst_subu|
                             inst_slt|inst_slti|inst_sltu|inst_sltiu|
                             inst_and|inst_andi|inst_or|inst_ori|inst_xor|inst_xori|
                             inst_sllv|inst_srav|inst_srlv;

    // pc to reg1
    assign sel_alu_src1[1] = 1'b0;

    // sa_zero_extend to reg1
    assign sel_alu_src1[2] = inst_sll|inst_sra|inst_srl;

    
    // rt to reg2
    assign sel_alu_src2[0] = inst_add|inst_addi|;
    
    // imm_sign_extend to reg2
    assign sel_alu_src2[1] = inst_lui | inst_addiu;

    // 32'b8 to reg2
    assign sel_alu_src2[2] = 1'b0;

    // imm_zero_extend to reg2
    assign sel_alu_src2[3] = inst_ori;



    assign op_add = inst_addiu;
    assign op_sub = 1'b0;
    assign op_slt = 1'b0;
    assign op_sltu = 1'b0;
    assign op_and = 1'b0;
    assign op_nor = 1'b0;
    assign op_or = inst_ori;
    assign op_xor = 1'b0;
    assign op_sll = 1'b0;
    assign op_srl = 1'b0;
    assign op_sra = 1'b0;
    assign op_lui = inst_lui;

    assign alu_op = {op_add, op_sub, op_slt, op_sltu,
                     op_and, op_nor, op_or, op_xor,
                     op_sll, op_srl, op_sra, op_lui};



    // load and store enable
    assign data_ram_en = 1'b0;

    // write enable
    assign data_ram_wen = 1'b0;



    // regfile sotre enable
    assign rf_we = inst_ori | inst_lui | inst_addiu;



    // store in [rd]
    assign sel_rf_dst[0] = 1'b0;
    // store in [rt] 
    assign sel_rf_dst[1] = inst_ori | inst_lui | inst_addiu;
    // store in [31]
    assign sel_rf_dst[2] = 1'b0;

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

    assign br_e = inst_beq & rs_eq_rt;
    assign br_addr = inst_beq ? (pc_plus_4 + {{14{inst[15]}},inst[15:0],2'b0}) : 32'b0;

    assign br_bus = {
        br_e,
        br_addr
    };
    


endmodule