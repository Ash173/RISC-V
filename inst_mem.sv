`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 11.08.2026 10:12:33
// Design Name: 
// Module Name: inst_mem
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


module inst_mem #(parameter WIDTH = 32)(
    input [WIDTH-1:0] addr,
    output [WIDTH-1:0] instr);
    
    reg [7:0] instr_mem [0:1023];
    
    //RISC-V is little endian
    assign instr = {instr_mem[addr+32'd3], instr_mem[addr + 32'd2], instr_mem[addr + 32'd1], instr_mem[addr]};
    
endmodule
