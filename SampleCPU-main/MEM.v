`include "lib/defines.vh"
module MEM(
    input wire clk,
    input wire rst,
    // input wire flush,
    input wire [`StallBus-1:0] stall,

    input wire [`EX_TO_MEM_WD-1:0] ex_to_mem_bus,
    input wire [31:0] data_sram_rdata,

    output wire [`MEM_TO_WB_WD-1:0] mem_to_wb_bus,
    output wire [`MEM_TO_RF_BUS-1:0] mem_to_rf_bus//Siri
);

    reg [`EX_TO_MEM_WD-1:0] ex_to_mem_bus_r;

    always @ (posedge clk) begin
        if (rst) begin
            ex_to_mem_bus_r <= `EX_TO_MEM_WD'b0;
        end
        // else if (flush) begin
        //     ex_to_mem_bus_r <= `EX_TO_MEM_WD'b0;
        // end
        else if (stall[3]==`Stop && stall[4]==`NoStop) begin
            ex_to_mem_bus_r <= `EX_TO_MEM_WD'b0;
        end
        else if (stall[3]==`NoStop) begin
            ex_to_mem_bus_r <= ex_to_mem_bus;
        end
        // else begin
        //     pass;
        // end
    end

    wire [31:0] mem_pc;
    wire data_ram_en;
    wire [3:0] data_ram_wen;
    wire sel_rf_res;
    wire rf_we;
    wire [4:0] rf_waddr;
    wire [31:0] rf_wdata;
    wire [31:0] ex_result;
    wire [31:0] mem_result;
    wire [5:0] ld_st_op;
    assign {
        ld_st_op,       // 81:76
        mem_pc,         // 75:44                                                                                                                                              
        data_ram_en,    // 43
        data_ram_wen,   // 42:39
        sel_rf_res,     // 38
        rf_we,          // 37
        rf_waddr,       // 36:32
        ex_result       // 31:0
    } =  ex_to_mem_bus_r;

    //load store 相关
    wire inst_lw;
    assign inst_lw=(ld_st_op==6'b10_0011);
    wire inst_sw;
    assign inst_sw=(ld_st_op==6'b10_1011);
    
    assign mem_result=inst_lw?data_sram_rdata:32'b0;


    assign rf_wdata = sel_rf_res ? mem_result : ex_result;

    assign mem_to_wb_bus = {
        mem_pc,     // 41:38
        rf_we,      // 37
        rf_waddr,   // 36:32
        rf_wdata    // 31:0
    };
    
    
    //Siri
    wire mem_to_rf_we;
    wire [4:0] mem_to_rf_waddr;
    wire [31:0] mem_to_rf_wdata;
    assign mem_to_rf_we =rf_we;
    assign mem_to_rf_waddr=rf_waddr;
    assign mem_to_rf_wdata=rf_wdata;
    assign mem_to_rf_bus={
        mem_to_rf_we,
        mem_to_rf_waddr,
        mem_to_rf_wdata
    };
    //Siri



endmodule