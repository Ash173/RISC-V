`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 12.08.2026 12:37:55
// Design Name: 
// Module Name: ex_mem_reg
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


module ex_mem_reg(clk, reset, stall, flush,
    alu_result_in, rs2_data_in, mem_write_in, mem_read_in, mem_to_reg_in, reg_write_in, rd_addr_in,
    alu_result_out, rs2_data_out, mem_write_out, mem_read_out, mem_to_reg_out, reg_write_out, rd_addr_out);

    input clk, reset, stall, flush;
    input [31:0] alu_result_in, rs2_data_in;
    input mem_write_in, mem_read_in, mem_to_reg_in, reg_write_in;
    input [4:0] rd_addr_in;

    output [31:0] alu_result_out, rs2_data_out;
    output mem_write_out, mem_read_out, mem_to_reg_out, reg_write_out;
    output [4:0] rd_addr_out;

    reg [31:0] r_alu_result, r_rs2_data;
    reg        r_mem_write, r_mem_read, r_mem_to_reg, r_reg_write;
    reg [4:0]  r_rd_addr;

    always @(posedge clk) begin
        if (reset) begin
            r_alu_result <= 0;
            r_rs2_data   <= 0;
            r_mem_write  <= 0;
            r_mem_read   <= 0;
            r_mem_to_reg <= 0;
            r_reg_write  <= 0;
            r_rd_addr    <= 0;
        end
        else if (flush) begin
            r_alu_result <= 0;
            r_rs2_data   <= 0;
            r_mem_write  <= 0;
            r_mem_read   <= 0;
            r_mem_to_reg <= 0;
            r_reg_write  <= 0;
            r_rd_addr    <= 0;
        end
        else if (stall) begin
            r_alu_result <= r_alu_result;
            r_rs2_data   <= r_rs2_data;
            r_mem_write  <= r_mem_write;
            r_mem_read   <= r_mem_read;
            r_mem_to_reg <= r_mem_to_reg;
            r_reg_write  <= r_reg_write;
            r_rd_addr    <= r_rd_addr;
        end
        else begin
            r_alu_result <= alu_result_in;
            r_rs2_data   <= rs2_data_in;
            r_mem_write  <= mem_write_in;
            r_mem_read   <= mem_read_in;
            r_mem_to_reg <= mem_to_reg_in;
            r_reg_write  <= reg_write_in;
            r_rd_addr    <= rd_addr_in;
        end
    end

    assign alu_result_out = r_alu_result;
    assign rs2_data_out   = r_rs2_data;
    assign mem_write_out  = r_mem_write;
    assign mem_read_out   = r_mem_read;
    assign mem_to_reg_out = r_mem_to_reg;
    assign reg_write_out  = r_reg_write;
    assign rd_addr_out    = r_rd_addr;

endmodule
