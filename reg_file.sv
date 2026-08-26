`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 11.08.2026 10:32:57
// Design Name: 
// Module Name: reg_file
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


module reg_file #(parameter WIDTH = 32, parameter ADDR = 5)
    (rs1_addr, rs2_addr, rd_addr, rs1, rs2, clk, reg_write, wr_data, reset);
    
    input [ADDR-1:0] rs1_addr, rs2_addr, rd_addr;
    input clk, reg_write, reset;
    input [WIDTH-1:0] wr_data;
    output [WIDTH-1:0] rs1, rs2;   // rd is not required, since we are writing
    
    reg [31:0] register_file [0:31];
    
    always @(posedge clk) begin
        if(reset) register_file[0] <= '0;
        else if(reg_write && (rd_addr != '0)) register_file[rd_addr] <= wr_data;
    end
    
    assign rs1 = register_file[rs1_addr];
    assign rs2 = register_file[rs2_addr];
endmodule
