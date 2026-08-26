`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 11.08.2026 13:54:43
// Design Name: 
// Module Name: control_unit
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


module control_unit #(parameter opcode_size = 7)(opcode, reg_write, alu_src, mem_write, mem_read, branch, mem_to_reg, imm_src, alu_op);

input [opcode_size-1:0] opcode;
output reg reg_write, alu_src, mem_write, mem_read, branch, mem_to_reg;
output reg [1:0] imm_src,alu_op;

always @(*) begin
    case(opcode)
        7'b0110011 : begin
            reg_write = 1'b1;
            alu_src = 1'b0;
            mem_write = 1'b0;
            mem_read = 1'b0;
            branch = 1'b0;
            mem_to_reg = 1'b0;
            imm_src = 2'b11;
            alu_op = 2'b10;
        end
        7'b0000011 : begin
            reg_write = 1'b1;
            alu_src = 1'b1;
            mem_write = 1'b0;
            mem_read = 1'b1;
            branch = 1'b0;
            mem_to_reg = 1'b1;
            imm_src = 2'b00;
            alu_op = 2'b00;
        end
        7'b0100011 : begin
            reg_write = 1'b0;
            alu_src = 1'b1;
            mem_write = 1'b1;
            mem_read = 1'b0;
            branch = 1'b0;
            mem_to_reg = 1'b0;
            imm_src = 2'b01;
            alu_op = 2'b00;
        end
        7'b1100011 : begin
            reg_write = 1'b0;
            alu_src = 1'b0;
            mem_write = 1'b0;
            mem_read = 1'b0;
            branch = 1'b1;
            mem_to_reg = 1'b0;
            imm_src = 2'b10;
            alu_op = 2'b01;
        end
        default: begin
            reg_write = 1'b0;
            alu_src = 1'b0;
            mem_write = 1'b0;
            mem_read = 1'b0;
            branch = 1'b0;
            mem_to_reg = 1'b0;
            imm_src = 2'b00;
            alu_op = 2'b00;
        end
    endcase
end

endmodule
