`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 11.08.2026 10:03:41
// Design Name: 
// Module Name: program_counter
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


module program_counter #(parameter WIDTH = 32)(
input clk,
input reset,
input [WIDTH-1:0] pc_next,
output reg [WIDTH-1:0] pc_current);

always @(posedge clk) begin
    if(reset) pc_current <= '0;
    else pc_current <= pc_next;
end
endmodule
