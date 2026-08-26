`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 11.08.2026 14:27:40
// Design Name: 
// Module Name: alu_control_unit
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


module alu_control_unit( alu_op, func3, func7_bit30, alu_control);
input [1:0] alu_op;
input [2:0] func3;
input func7_bit30;
output reg [3:0] alu_control;

always @(*) begin
    case(alu_op)
        2'b00: alu_control = 4'b0010;
        2'b01: alu_control = 4'b0110;
        2'b10: begin
            case(func3)
                3'b000: alu_control = func7_bit30 ? 4'b0110 : 4'b0010;  // sub : add
                3'b001: alu_control = 4'b0100;                           // sll
                3'b100: alu_control = 4'b0011;                           // xor
                3'b101: alu_control = func7_bit30 ? 4'b0111 : 4'b0101;  // sra : srl
                3'b110: alu_control = 4'b0001;                           // or
                3'b111: alu_control = 4'b0000;                           // and
                default: alu_control = 4'b0010;
            endcase
        end
        default: alu_control = 4'b0010;
    endcase
end
endmodule
