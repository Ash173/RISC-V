`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 11.08.2026 14:42:50
// Design Name: 
// Module Name: data_mem
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


module data_mem #(parameter WIDTH = 32)(
    input clk,
    input mem_write,
    input mem_read,
    input [WIDTH-1:0] addr,
    input [WIDTH-1:0] write_data,
    output [WIDTH-1:0] read_data
);

    reg [7:0] data_memr [0:1023];

    // 1) combinational read - same little-endian pattern as inst_mem, just renamed
    assign read_data = {data_memr[addr+32'd3], data_memr[addr + 32'd2], data_memr[addr + 32'd1], data_memr[addr]}; /* your 4-byte concatenation here, high byte first */ 

    // 2) synchronous write - using the slices you already gave me: 7:0, 15:8, 23:16, 31:24
    always @(posedge clk) begin
        if (mem_write) begin
            data_memr[addr]   <= write_data[7:0];
            data_memr[addr+1] <= write_data[15:8];
            data_memr[addr+2] <= write_data[23:16];
            data_memr[addr+3] <= write_data[31:24];
        end
    end

endmodule
