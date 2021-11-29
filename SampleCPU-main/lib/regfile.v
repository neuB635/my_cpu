`include "defines.vh"
module regfile(
    input wire clk,


    //读端口1
    input wire [4:0] raddr1,
    output wire [31:0] rdata1,

    //读端口2
    input wire [4:0] raddr2,
    output wire [31:0] rdata2,
    
    //写端口
    input wire we,
    input wire [4:0] waddr,
    input wire [31:0] wdata
);
    reg [31:0] reg_array [31:0];
    // write
    always @ (posedge clk) begin
        if (we && waddr!=5'b0) begin //也就是we不为000000，waddr不为000000时。
            reg_array[waddr] <= wdata;
        end
    end
    
    // read out 1
    assign rdata1 = (raddr1 == 5'b0) ? 32'b0 : (raddr1==waddr)&&(we==`WriteEnable)? wdata :reg_array[raddr1];

    // read out2
    assign rdata2 = (raddr2 == 5'b0) ? 32'b0 : (raddr2==waddr)&&(we==`WriteEnable)? wdata :reg_array[raddr2];

endmodule