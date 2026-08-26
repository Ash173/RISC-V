`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 11.08.2026 13:09:29
// Design Name: 
// Module Name: imm_gen
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


module imm_gen #(parameter WIDTH = 32)(
    input  [WIDTH-1:0] instr,
    input  [1:0] imm_src,
    output [WIDTH-1:0] sign_ext_value
);
    reg [WIDTH-1:0] imm_sign_ext_value;

    always @(*) begin
        case(imm_src)
            2'b00: imm_sign_ext_value = {{20{instr[31]}}, instr[31:20]};                                              // I-type
            2'b01: imm_sign_ext_value = {{20{instr[31]}}, instr[31:25], instr[11:7]};                                  // S-type
            2'b10: imm_sign_ext_value = {{19{instr[31]}}, instr[31], instr[7], instr[30:25], instr[11:8], 1'b0};       // B-type
            default: imm_sign_ext_value = 32'b0;
        endcase
    end

    assign sign_ext_value = imm_sign_ext_value;
endmodule
