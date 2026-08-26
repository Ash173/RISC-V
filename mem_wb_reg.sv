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

module mem_wb_reg(clk, reset, stall, flush,
    read_data_in, alu_result_in, mem_to_reg_in, reg_write_in, rd_addr_in,
    read_data_out, alu_result_out, mem_to_reg_out, reg_write_out, rd_addr_out);

    input clk, reset, stall, flush;
    input [31:0] read_data_in, alu_result_in;
    input mem_to_reg_in, reg_write_in;
    input [4:0] rd_addr_in;

    output [31:0] read_data_out, alu_result_out;
    output mem_to_reg_out, reg_write_out;
    output [4:0] rd_addr_out;

    reg [31:0] r_read_data, r_alu_result;
    reg        r_mem_to_reg, r_reg_write;
    reg [4:0]  r_rd_addr;

    always @(posedge clk) begin
        if (reset) begin
            r_read_data  <= 0;
            r_alu_result <= 0;
            r_mem_to_reg <= 0;
            r_reg_write  <= 0;
            r_rd_addr    <= 0;
        end
        else if (flush) begin
            r_read_data  <= 0;
            r_alu_result <= 0;
            r_mem_to_reg <= 0;
            r_reg_write  <= 0;
            r_rd_addr    <= 0;
        end
        else if (stall) begin
            r_read_data  <= r_read_data;
            r_alu_result <= r_alu_result;
            r_mem_to_reg <= r_mem_to_reg;
            r_reg_write  <= r_reg_write;
            r_rd_addr    <= r_rd_addr;
        end
        else begin
            r_read_data  <= read_data_in;
            r_alu_result <= alu_result_in;
            r_mem_to_reg <= mem_to_reg_in;
            r_reg_write  <= reg_write_in;
            r_rd_addr    <= rd_addr_in;
        end
    end

    assign read_data_out  = r_read_data;
    assign alu_result_out = r_alu_result;
    assign mem_to_reg_out = r_mem_to_reg;
    assign reg_write_out  = r_reg_write;
    assign rd_addr_out    = r_rd_addr;

endmodule