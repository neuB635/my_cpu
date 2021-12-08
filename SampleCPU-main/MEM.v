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
    wire[4:0]new_lb_lw_lh;
    assign {
        new_lb_lw_lh,
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
    wire mem_inst_lw;
    assign mem_inst_lw=(ld_st_op==6'b10_0011);
    // wire mem_inst_sw;
    // assign mem_inst_sw=(ld_st_op==6'b10_1011);
    wire mem_inst_lb;
    assign mem_inst_lb=(ld_st_op==6'b100000)|(ld_st_op==6'b100100);
    wire mem_inst_lh;
    assign mem_inst_lh=(ld_st_op==6'b100001)|(ld_st_op==6'b100101);
    

    assign mem_result=mem_inst_lw?data_sram_rdata: 
                      (mem_inst_lb&(new_lb_lw_lh==5'b1_1000))?{{24{data_sram_rdata[7]}},data_sram_rdata[7:0]}:
                      (mem_inst_lb&(new_lb_lw_lh==5'b1_0100))?{{24{data_sram_rdata[15]}},data_sram_rdata[15:8]}:
                      (mem_inst_lb&(new_lb_lw_lh==5'b1_0010))?{{24{data_sram_rdata[23]}},data_sram_rdata[23:16]}:
                      (mem_inst_lb&(new_lb_lw_lh==5'b1_0001))?{{24{data_sram_rdata[31]}},data_sram_rdata[31:24]}:
                      (mem_inst_lh&(new_lb_lw_lh==5'b1_1100))?{{16{data_sram_rdata[15]}},data_sram_rdata[15:0]}:
                      (mem_inst_lh&(new_lb_lw_lh==5'b1_0011))?{{16{data_sram_rdata[31]}},data_sram_rdata[31:16]}:
                      (mem_inst_lb&(new_lb_lw_lh==5'b0_1000))?{24'b0,data_sram_rdata[7:0]}:
                      (mem_inst_lb&(new_lb_lw_lh==5'b0_0100))?{24'b0,data_sram_rdata[15:8]}:
                      (mem_inst_lb&(new_lb_lw_lh==5'b0_0010))?{24'b0,data_sram_rdata[23:16]}:
                      (mem_inst_lb&(new_lb_lw_lh==5'b0_0001))?{24'b0,data_sram_rdata[31:24]}:
                      (mem_inst_lh&(new_lb_lw_lh==5'b0_1100))?{16'b0,data_sram_rdata[15:0]}:
                      (mem_inst_lh&(new_lb_lw_lh==5'b0_0011))?{16'b0,data_sram_rdata[31:16]}:32'b0;


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