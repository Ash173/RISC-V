`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 12.08.2026 10:45:03
// Design Name: 
// Module Name: if_id_reg
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


module if_id_reg #(parameter WIDTH = 32)(clk,reset,stall,flush,instr_in, pc_in, instr_out, pc_out);
    input clk, reset;
    input stall, flush;
    input [WIDTH-1:0] instr_in, pc_in;
    output [WIDTH-1:0] instr_out, pc_out;
    
    reg [WIDTH-1:0] reg_instr_out, reg_pc_out;
    
    always @(posedge clk) begin
        if(reset) begin
            reg_instr_out <= '0;
            reg_pc_out <= '0;
        end
        else if(flush) begin
            reg_instr_out <= '0;
            reg_pc_out <= '0;
        end
        else if(stall) begin
            reg_instr_out <= reg_instr_out;
            reg_pc_out <= reg_pc_out;
        end
        else begin
            reg_instr_out <= instr_in;
            reg_pc_out <= pc_in;
        end
    end
    
    assign instr_out = reg_instr_out;
    assign pc_out = reg_pc_out;
endmodule
