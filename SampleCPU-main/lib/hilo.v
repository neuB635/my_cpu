`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2021/12/05 20:33:25
// Design Name: 
// Module Name: hilo
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module hilo(
    input wire clk,
    input wire rst,

    //写端口
    input wire we,
    input wire [63:0] hilo_data,

    //读端口
    output wire [31:0] hi,
    output wire [31:0] lo
    );
    reg [31:0] get_hi;
    reg [31:0] get_lo;
    always @(posedge clk) begin
        if (rst == 1'b1) begin
            get_hi <= 32'b0;
            get_lo <= 32'b0;
        end
        else if ((we == 1'b1)) begin
            {get_hi,get_lo} <= hilo_data;
        end
    end

    assign hi = get_hi;
    assign lo = get_lo;



endmodule
