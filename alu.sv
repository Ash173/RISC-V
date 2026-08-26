`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 11.08.2026 11:33:40
// Design Name: 
// Module Name: alu
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


module alu #(parameter WIDTH = 32)(operand_a, operand_b, alu_control, result, is_zero);
    input [WIDTH-1:0] operand_a, operand_b;
    input [3:0] alu_control;
    output [WIDTH-1:0]result;
    output is_zero;
    
    reg [WIDTH-1:0] imm_result;
    
    always @(*)begin
        case(alu_control)
            4'b0000 : imm_result = operand_a & operand_b;
            4'b0001 : imm_result = operand_a | operand_b;
            4'b0010 : imm_result = operand_a + operand_b;
            4'b0011 : imm_result = operand_a ^ operand_b;
            4'b0100 : imm_result = operand_a << operand_b[4:0];
            4'b0101 : imm_result = operand_a >> operand_b[4:0];
            4'b0110 : imm_result = operand_a - operand_b;
            4'b0111 : imm_result = $signed(operand_a) >>> operand_b[4:0];
            default : imm_result = operand_a;
        endcase
    end
    assign result = imm_result;
    assign is_zero = (imm_result == {WIDTH{1'b0}});
endmodule
