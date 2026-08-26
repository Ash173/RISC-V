`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 12.08.2026 20:45:08
// Design Name: 
// Module Name: forwarding_unit
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


module forwarding_unit(
    rs1_addr_ex, rs2_addr_ex,
    rd_addr_mem, reg_write_mem,
    rd_addr_wb, reg_write_wb,
    forward_a, forward_b
);
    input [4:0] rs1_addr_ex, rs2_addr_ex;
    input [4:0] rd_addr_mem, rd_addr_wb;
    input reg_write_mem, reg_write_wb;
    output reg [1:0] forward_a, forward_b;
    // forward_a/forward_b encoding: 2'b00 = no forward (use rs_data_ex), 
    //                                2'b01 = forward from EX/MEM,
    //                                2'b10 = forward from MEM/WB

    always @(*) begin
        // forward_a - for rs1
        if (reg_write_mem && (rd_addr_mem != 5'd0) && (rd_addr_mem == rs1_addr_ex))
            forward_a = 2'b01;
        else if (reg_write_wb && (rd_addr_wb != 5'd0) && (rd_addr_wb == rs1_addr_ex))
            forward_a = 2'b10;
        else
            forward_a = 2'b00;

        // forward_b - for rs2
        if (reg_write_mem && (rd_addr_mem != 5'd0) && (rd_addr_mem == rs2_addr_ex))
            forward_b = 2'b01;
        else if (reg_write_wb && (rd_addr_wb != 5'd0) && (rd_addr_wb == rs2_addr_ex))
            forward_b = 2'b10;
        else
            forward_b = 2'b00;
    end
endmodule
