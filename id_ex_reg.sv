`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 12.08.2026 12:28:04
// Design Name: 
// Module Name: id_ex_reg
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


module id_ex_reg(clk, reset, stall, flush, rs1_data_in, rs2_data_in, sign_ext_value_in, pc_current_in, alu_op_in, func3_in, func7_bit30_in, alu_src_in, branch_in, mem_write_in, mem_read_in, mem_to_reg_in, reg_write_in, rd_addr_in,
rs1_data_out, rs2_data_out, sign_ext_value_out, pc_current_out, alu_op_out, func3_out, func7_bit30_out, alu_src_out, branch_out, mem_write_out, mem_read_out, mem_to_reg_out, reg_write_out, rd_addr_out, rs1_addr_in, rs1_addr_out, rs2_addr_in, rs2_addr_out);

    input clk, reset, stall, flush;
    input [4:0] rs1_addr_in, rs2_addr_in;
    input [31:0] rs1_data_in, rs2_data_in, sign_ext_value_in, pc_current_in;
    input [1:0] alu_op_in;
    input [2:0] func3_in;
    input func7_bit30_in;
    input alu_src_in, branch_in, mem_write_in, mem_read_in, mem_to_reg_in, reg_write_in;
    input [4:0] rd_addr_in;

    output [31:0] rs1_data_out, rs2_data_out, sign_ext_value_out, pc_current_out;
    output [4:0] rs1_addr_out, rs2_addr_out;
    output [1:0] alu_op_out;
    output [2:0] func3_out;
    output func7_bit30_out;
    output alu_src_out, branch_out, mem_write_out, mem_read_out, mem_to_reg_out, reg_write_out;
    output [4:0] rd_addr_out;
    
    reg [31:0] r_rs1_data, r_rs2_data, r_sign_ext_value, r_pc_current;
    reg [1:0]  r_alu_op;
    reg [2:0]  r_func3;
    reg        r_func7_bit30;
    reg        r_alu_src, r_branch, r_mem_write, r_mem_read, r_mem_to_reg, r_reg_write;
    reg [4:0]  r_rd_addr;
    reg [4:0] r_rs1_addr, r_rs2_addr;

    always @(posedge clk) begin
        if (reset) begin
            r_rs1_data      <= 0;
            r_rs2_data      <= 0;
            r_sign_ext_value<= 0;
            r_pc_current    <= 0;
            r_alu_op        <= 0;
            r_func3         <= 0;
            r_func7_bit30   <= 0;
            r_alu_src       <= 0;
            r_branch        <= 0;
            r_mem_write     <= 0;
            r_mem_read      <= 0;
            r_mem_to_reg    <= 0;
            r_reg_write     <= 0;
            r_rd_addr       <= 0;
            r_rs1_addr      <= 0;
            r_rs2_addr      <= 0;
        end
        else if (flush) begin
            r_rs1_data      <= 0;
            r_rs2_data      <= 0;
            r_sign_ext_value<= 0;
            r_pc_current    <= 0;
            r_alu_op        <= 0;
            r_func3         <= 0;
            r_func7_bit30   <= 0;
            r_alu_src       <= 0;
            r_branch        <= 0;
            r_mem_write     <= 0;
            r_mem_read      <= 0;
            r_mem_to_reg    <= 0;
            r_reg_write     <= 0;
            r_rd_addr       <= 0;
            r_rs1_addr      <= 0;
            r_rs2_addr      <= 0;
        end
        else if (stall) begin
            // hold current values - no assignment needed, but explicit for clarity
            r_rs1_data      <= r_rs1_data;
            r_rs2_data      <= r_rs2_data;
            r_sign_ext_value<= r_sign_ext_value;
            r_pc_current    <= r_pc_current;
            r_alu_op        <= r_alu_op;
            r_func3         <= r_func3;
            r_func7_bit30   <= r_func7_bit30;
            r_alu_src       <= r_alu_src;
            r_branch        <= r_branch;
            r_mem_write     <= r_mem_write;
            r_mem_read      <= r_mem_read;
            r_mem_to_reg    <= r_mem_to_reg;
            r_reg_write     <= r_reg_write;
            r_rd_addr       <= r_rd_addr;
            r_rs1_addr      <= r_rs1_addr;
            r_rs2_addr      <= r_rs2_addr;
        end
        else begin
            r_rs1_data      <= rs1_data_in;
            r_rs2_data      <= rs2_data_in;
            r_sign_ext_value<= sign_ext_value_in;
            r_pc_current    <= pc_current_in;
            r_alu_op        <= alu_op_in;
            r_func3         <= func3_in;
            r_func7_bit30   <= func7_bit30_in;
            r_alu_src       <= alu_src_in;
            r_branch        <= branch_in;
            r_mem_write     <= mem_write_in;
            r_mem_read      <= mem_read_in;
            r_mem_to_reg    <= mem_to_reg_in;
            r_reg_write     <= reg_write_in;
            r_rd_addr       <= rd_addr_in;
            r_rs1_addr      <= rs1_addr_in;
            r_rs2_addr      <= rs2_addr_in;
        end
    end

    assign rs1_data_out       = r_rs1_data;
    assign rs2_data_out       = r_rs2_data;
    assign sign_ext_value_out = r_sign_ext_value;
    assign pc_current_out     = r_pc_current;
    assign alu_op_out         = r_alu_op;
    assign func3_out          = r_func3;
    assign func7_bit30_out    = r_func7_bit30;
    assign alu_src_out        = r_alu_src;
    assign branch_out         = r_branch;
    assign mem_write_out      = r_mem_write;
    assign mem_read_out       = r_mem_read;
    assign mem_to_reg_out     = r_mem_to_reg;
    assign reg_write_out      = r_reg_write;
    assign rd_addr_out        = r_rd_addr;
    assign rs1_addr_out       = r_rs1_addr;
    assign rs2_addr_out       = r_rs2_addr;

endmodule
