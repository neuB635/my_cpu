`include "lib/defines.vh"
module mycpu_core(
    input wire clk,
    input wire rst,
    input wire [5:0] int,

    output wire inst_sram_en,
    output wire [3:0] inst_sram_wen,
    output wire [31:0] inst_sram_addr,
    output wire [31:0] inst_sram_wdata,
    input wire [31:0] inst_sram_rdata,

    output wire data_sram_en,
    output wire [3:0] data_sram_wen,
    output wire [31:0] data_sram_addr,
    output wire [31:0] data_sram_wdata,
    input wire [31:0] data_sram_rdata,

    output wire [31:0] debug_wb_pc,
    output wire [3:0] debug_wb_rf_wen,
    output wire [4:0] debug_wb_rf_wnum,
    output wire [31:0] debug_wb_rf_wdata,
    output wire id_stall_req
);
    wire [`IF_TO_ID_WD-1:0] if_to_id_bus;
    wire [`ID_TO_EX_WD-1:0] id_to_ex_bus;
    wire [`EX_TO_MEM_WD-1:0] ex_to_mem_bus;
    wire [`MEM_TO_WB_WD-1:0] mem_to_wb_bus;
    wire [`BR_WD-1:0] br_bus; 
    wire [`DATA_SRAM_WD-1:0] ex_dt_sram_bus;
    wire [`WB_TO_RF_WD-1:0] wb_to_rf_bus;
    wire [`StallBus-1:0] stall;
    //Siri
    wire [`EX_TO_RF_BUS-1:0] ex_to_rf_bus;
    wire [`MEM_TO_RF_BUS-1:0] mem_to_rf_bus;
    wire stallreq_for_ex;
    wire stallreq_for_load;
    ///
    wire [32:0] delay_to_ex;
    ///

    IF u_IF(
    	.clk             (clk             ),  //in
        .rst             (rst             ),  //in
        .stall           (stall           ),  //in
        .br_bus          (br_bus          ),  //in
        .if_to_id_bus    (if_to_id_bus    ),  //out
        .inst_sram_en    (inst_sram_en    ),  //out
        .inst_sram_wen   (inst_sram_wen   ),  //out
        .inst_sram_addr  (inst_sram_addr  ),  //out
        .inst_sram_wdata (inst_sram_wdata )   //out
    );
    

    ID u_ID(
    	.clk             (clk             ),//in
        .rst             (rst             ),//in
        .stall           (stall           ),//in
        .stallreq        (id_stall_req     ),//out
        .if_to_id_bus    (if_to_id_bus    ),//in
        .inst_sram_rdata (inst_sram_rdata ),//in
        .wb_to_rf_bus    (wb_to_rf_bus    ),//in
        .ex_to_rf_bus    (ex_to_rf_bus    ),//Siri  //in
        .mem_to_rf_bus   (mem_to_rf_bus   ),//Siri //in
        .id_to_ex_bus    (id_to_ex_bus    ),//out
        .br_bus          (br_bus          ),//out
        .delay_to_ex   (delay_to_ex)//out
    );

    EX u_EX(
    	.clk             (clk             ),//in
        .rst             (rst             ),//in
        .stall           (stall           ),//in
        .id_to_ex_bus    (id_to_ex_bus    ),//in
        .ex_to_mem_bus   (ex_to_mem_bus   ),//out
        .data_sram_en    (data_sram_en    ),//out
        .data_sram_wen   (data_sram_wen   ),//out
        .data_sram_addr  (data_sram_addr  ),//out
        .data_sram_wdata (data_sram_wdata ),//out
        .ex_to_rf_bus    (ex_to_rf_bus    ),//Siri //out
        .delay_ex   (delay_to_ex)    //in
    );

    MEM u_MEM(
    	.clk             (clk             ),//in
        .rst             (rst             ),//in
        .stall           (stall           ),//in
        .ex_to_mem_bus   (ex_to_mem_bus   ),//in
        .data_sram_rdata (data_sram_rdata ),//in
        .mem_to_wb_bus   (mem_to_wb_bus   ),//out
        .mem_to_rf_bus   (mem_to_rf_bus   )//Siri  //out
    );
    
    WB u_WB(
    	.clk               (clk               ),//in
        .rst               (rst               ),//in
        .stall             (stall             ),//in
        .mem_to_wb_bus     (mem_to_wb_bus     ),//in
        .wb_to_rf_bus      (wb_to_rf_bus      ),//out
        .debug_wb_pc       (debug_wb_pc       ),//out
        .debug_wb_rf_wen   (debug_wb_rf_wen   ),//out
        .debug_wb_rf_wnum  (debug_wb_rf_wnum  ),//out
        .debug_wb_rf_wdata (debug_wb_rf_wdata )//out
    );

    CTRL u_CTRL(
    	.rst   (rst   ),//in
        //.stallreq_for_ex    (stallreq_for_ex),//Siri
        //.stallreq_for_load  (stallreq_for_load),//Siri
        .id_stall_req (id_stall_req),//in
        .stall (stall )//out
    );
    
endmodule