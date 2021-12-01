`include "lib/defines.vh"
module CTRL(
    input wire rst,
    input wire id_stall_req, //id段传来的停止信号
    // input wire stallreq_for_ex,
    // input wire stallreq_for_load,

    // output reg flush,
    // output reg [31:0] new_pc,
    output reg [`StallBus-1:0] stall
);  
    always @ (*) begin
        if (rst) begin
            stall = `StallBus'b0;
        end
        ///
        else if (id_stall_req==`Stop) begin
            stall = `StallBus'b000111;
            end
        ///
        else begin
            stall = `StallBus'b0;
        end
    end

endmodule