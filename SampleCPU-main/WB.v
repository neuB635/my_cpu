`include "lib/defines.vh"
module WB(
    input wire clk,//传入时钟周期
    input wire rst,//复位信号，负责初始化各项数据
    input wire [`StallBus-1:0] stall,//停止信号，负责暂停流水线
    input wire [`MEM_TO_WB_WD-1:0] mem_to_wb_bus,//MEM段到WB段的总线
    output wire [`WB_TO_RF_WD-1:0] wb_to_rf_bus,//WB段到ID段的总线
    //debug用来判断程序是否正确运行
    output wire [31:0] debug_wb_pc, // 当前的指令
    output wire [3:0] debug_wb_rf_wen,//当前的写入使能
    output wire [4:0] debug_wb_rf_wnum,//当前的写入地址
    output wire [31:0] debug_wb_rf_wdata //当前的写入数据
    // input wire flush,
);

    reg [`MEM_TO_WB_WD-1:0] mem_to_wb_bus_r;

    always @ (posedge clk) begin
        if (rst) begin
            mem_to_wb_bus_r <= `MEM_TO_WB_WD'b0;
        end
        // else if (flush) begin
        //     mem_to_wb_bus_r <= `MEM_TO_WB_WD'b0;
        // end
        else if (stall[4]==`Stop && stall[5]==`NoStop) begin
            mem_to_wb_bus_r <= `MEM_TO_WB_WD'b0;
        end
        else if (stall[4]==`NoStop) begin
            mem_to_wb_bus_r <= mem_to_wb_bus;
        end
    end

    wire [31:0] wb_pc;
    wire rf_we;
    wire [4:0] rf_waddr;
    wire [31:0] rf_wdata;

    assign {
        wb_pc,
        rf_we,
        rf_waddr,
        rf_wdata
    } = mem_to_wb_bus_r;

    // assign wb_to_rf_bus = mem_to_wb_bus_r[`WB_TO_RF_WD-1:0];

    assign wb_to_rf_bus = {
        rf_we,
        rf_waddr,
        rf_wdata
    };

    assign debug_wb_pc = wb_pc;
    assign debug_wb_rf_wen = {4{rf_we}};
    assign debug_wb_rf_wnum = rf_waddr;
    assign debug_wb_rf_wdata = rf_wdata;

    
endmodule