`include "lib/defines.vh"
module IF(
    input wire clk,  //传入时钟周期
    input wire rst,  //复位信号，负责初始化各项数据
    input wire [`StallBus-1:0] stall, //停止信号，负责暂停流水线
    input wire [`BR_WD-1:0] br_bus,   //从ID段传入，存放指令跳转的相关信息
    output wire [`IF_TO_ID_WD-1:0] if_to_id_bus,  //IF段到ID段的总线，将IF段的数据进行打包
    output wire inst_sram_en, //能不能从内存读取指令的使能
    output wire [3:0] inst_sram_wen,//能不能向内存中写入数据的使能
    output wire [31:0] inst_sram_addr,//写入内存时的写入地址
    output wire [31:0] inst_sram_wdata//写入内存的数据
    // input wire flush,
    // input wire [31:0] new_pc,
);
    reg [31:0] pc_reg;
    reg ce_reg;
    wire [31:0] next_pc;
    wire br_e;
    wire [31:0] br_addr;

    assign {
        br_e,
        br_addr
    } = br_bus;


    always @ (posedge clk) begin
        if (rst) begin
            pc_reg <= 32'hbfbf_fffc;
        end
        else if (stall[0]==`NoStop) begin
            pc_reg <= next_pc;
        end
    end

    always @ (posedge clk) begin
        if (rst) begin
            ce_reg <= 1'b0;
        end
        else if (stall[0]==`NoStop) begin
            ce_reg <= 1'b1;
        end
    end


    assign next_pc = br_e ? br_addr 
                   : pc_reg + 32'h4;
    //判断是否需要跳转，若跳转使用传进来的跳转地址，否则选择pc+4

    
    assign inst_sram_en = ce_reg;
    assign inst_sram_wen = 4'b0;
    assign inst_sram_addr = pc_reg;
    assign inst_sram_wdata = 32'b0;
    assign if_to_id_bus = {
        ce_reg,
        pc_reg
    };

endmodule