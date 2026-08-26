`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 12.08.2026 21:06:07
// Design Name: 
// Module Name: hazard_detection_unit
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


module hazard_detection_unit(
    mem_read_ex, rd_addr_ex, rs1_addr_id, rs2_addr_id, stall
);
    input mem_read_ex;
    input [4:0] rd_addr_ex;
    input [4:0] rs1_addr_id, rs2_addr_id;
    output reg stall;

    always @(*) begin
        if (mem_read_ex && (rd_addr_ex != 5'd0) &&
            ((rd_addr_ex == rs1_addr_id) || (rd_addr_ex == rs2_addr_id)))
            stall = 1'b1;
        else
            stall = 1'b0;
    end
endmodule
