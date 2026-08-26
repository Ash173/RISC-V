`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 11.08.2026 21:25:45
// Design Name: 
// Module Name: risc_v_single_cycle
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


//module risc_v_single_cycle #(parameter WIDTH = 32) (input clk, input reset);
//    wire [31:0] instruction;
    
//    // Split of ISA
//    wire [6:0] opcode = instruction[6:0];
//    wire [4:0] rs1_addr = instruction[19:15];
//    wire [4:0] rs2_addr = instruction[24:20];
//    wire [4:0] rd_addr = instruction[11:7];
//    wire [2:0] func3 = instruction[14:12];
//    wire func7_bit30 = instruction[30];
//    wire [WIDTH-1:0] pc_next;
//    wire [WIDTH-1:0] pc_current;
    
    
    
    
//    program_counter #(.WIDTH(WIDTH)) pc  (.clk(clk), .reset(reset), .pc_next(pc_next), .pc_current(pc_current));
//    inst_mem #(.WIDTH(WIDTH)) instr_mem (.addr(pc_current), .instr(instruction));
    
//    wire reg_write;
//    wire [WIDTH-1:0] wr_data;
//    wire [WIDTH-1:0] rs1, rs2;
//    reg_file #(.WIDTH(WIDTH), .ADDR(5)) r_file (.clk(clk), .reset(reset), .rs1_addr(rs1_addr), .rs2_addr(rs2_addr), .rd_addr(rd_addr), .rs1(rs1), .rs2(rs2),
//     .reg_write(reg_write), .wr_data(wr_data));
     
//     wire alu_src, mem_write, mem_read, branch, mem_to_reg;
//     wire [1:0] imm_src,alu_op;
     
//     control_unit #(.opcode_size(7)) con_unit (.opcode(opcode), .reg_write(reg_write), .mem_write(mem_write), .alu_src(alu_src),
//     .mem_read(mem_read), .branch(branch), .mem_to_reg(mem_to_reg), .imm_src(imm_src), .alu_op(alu_op));
//    wire [3:0] alu_control;
//    alu_control_unit alu_con_unit (.alu_op(alu_op), .func3(func3), .func7_bit30(func7_bit30), .alu_control(alu_control));
    
//    wire [WIDTH-1:0] sign_ext_value;
//    imm_gen #(.WIDTH(WIDTH)) sign_imm_gen (.instr(instruction), .imm_src(imm_src), .sign_ext_value(sign_ext_value));
    
//    wire [WIDTH-1:0] alu_operand_b;
//    assign alu_operand_b = alu_src ? sign_ext_value : rs2;
    
    
//    wire [WIDTH-1:0] result;
//    wire is_zero;
//    alu #(.WIDTH(WIDTH)) alu_inst (.operand_a(rs1), .operand_b(alu_operand_b), .result(result), .is_zero(is_zero), .alu_control(alu_control));
    
//    wire [WIDTH-1:0] read_data;
//    data_mem #(.WIDTH(WIDTH)) data_memr (.clk(clk), .mem_write(mem_write), .mem_read(mem_read), .addr(result), .write_data(rs2),
//    .read_data(read_data));
//    assign wr_data = mem_to_reg ? read_data : result;
//    wire [WIDTH-1:0] pc_plus4 = pc_current + 32'd4;
//    wire [WIDTH-1:0] branch_target = pc_current + sign_ext_value;
//    wire pc_src = branch & is_zero;
//    assign pc_next = pc_src ? branch_target : pc_plus4;
//endmodule

module riscv_pipeline #(parameter WIDTH = 32)(
    input clk, reset
);

    // ============ Forward declarations (needed because Forwarding Unit /
    // Hazard Detection Unit reference EX/MEM & MEM/WB signals) ============
    wire [WIDTH-1:0] alu_result_mem, rs2_data_mem;
    wire mem_write_mem, mem_read_mem, mem_to_reg_mem, reg_write_mem;
    wire [4:0] rd_addr_mem;

    wire [WIDTH-1:0] read_data_wb, alu_result_wb;
    wire mem_to_reg_wb;
    wire reg_write_wb;
    wire [WIDTH-1:0] wr_data_wb;
    wire [4:0] rd_addr_wb;

    // ============ IF stage ============
    wire [WIDTH-1:0] pc_current, pc_next, pc_plus4, instruction;
    wire branch_taken;
    wire [WIDTH-1:0] branch_target_addr;
    wire stall;

    assign pc_plus4 = pc_current + 32'd4;
    assign pc_next  = stall ? pc_current :
                       branch_taken ? branch_target_addr : pc_plus4;

    program_counter #(.WIDTH(WIDTH)) pc_inst (
        .clk(clk), .reset(reset),
        .pc_next(pc_next), .pc_current(pc_current)
    );

    inst_mem #(.WIDTH(WIDTH)) imem_inst (
        .addr(pc_current), .instr(instruction)
    );

    wire flush;
    wire [WIDTH-1:0] pc_if_id_out, instr_if_id_out;
    if_id_reg #(.WIDTH(WIDTH)) if_id_reg_inst (
        .clk(clk), .reset(reset), .stall(stall), .flush(flush),
        .pc_in(pc_current), .instr_in(instruction), .pc_out(pc_if_id_out), .instr_out(instr_if_id_out)
    );

    // ============ ID stage ============
    wire [6:0] opcode        = instr_if_id_out[6:0];
    wire [4:0] rs1_addr      = instr_if_id_out[19:15];
    wire [4:0] rs2_addr      = instr_if_id_out[24:20];
    wire [4:0] rd_addr_id    = instr_if_id_out[11:7];
    wire [2:0] func3_id      = instr_if_id_out[14:12];
    wire func7_bit30_id      = instr_if_id_out[30];

    wire [WIDTH-1:0] rs1_data, rs2_data;
    reg_file #(.WIDTH(WIDTH), .ADDR(5)) r_file (
        .clk(clk), .reset(reset),
        .rs1_addr(rs1_addr), .rs2_addr(rs2_addr), .rd_addr(rd_addr_wb),
        .rs1(rs1_data), .rs2(rs2_data),
        .reg_write(reg_write_wb), .wr_data(wr_data_wb)
    );

    wire alu_src_id, mem_write_id, mem_read_id, branch_id, mem_to_reg_id, reg_write_id;
    wire [1:0] imm_src, alu_op_id;

    control_unit #(.opcode_size(7)) con_unit (
        .opcode(opcode),
        .reg_write(reg_write_id), .mem_write(mem_write_id), .alu_src(alu_src_id),
        .mem_read(mem_read_id), .branch(branch_id), .mem_to_reg(mem_to_reg_id),
        .imm_src(imm_src), .alu_op(alu_op_id)
    );

    wire [WIDTH-1:0] sign_ext_value_id;
    imm_gen #(.WIDTH(WIDTH)) sign_imm_gen (
        .instr(instr_if_id_out), .imm_src(imm_src), .sign_ext_value(sign_ext_value_id)
    );

    wire ex_flush;

    wire [WIDTH-1:0] rs1_data_ex, rs2_data_ex, sign_ext_value_ex, pc_current_ex;
    wire [1:0] alu_op_ex;
    wire [2:0] func3_ex;
    wire func7_bit30_ex;
    wire alu_src_ex, branch_ex, mem_write_ex, mem_read_ex, mem_to_reg_ex, reg_write_ex;
    wire [4:0] rd_addr_ex;
    wire [4:0] rs1_addr_out, rs2_addr_out;

    id_ex_reg id_ex_reg_inst (
        .clk(clk), .reset(reset), .stall(1'b0), .flush(ex_flush),

        .rs1_data_in(rs1_data), .rs2_data_in(rs2_data),
        .sign_ext_value_in(sign_ext_value_id), .pc_current_in(pc_if_id_out),
        .alu_op_in(alu_op_id), .func3_in(func3_id), .func7_bit30_in(func7_bit30_id),
        .alu_src_in(alu_src_id), .branch_in(branch_id),
        .mem_write_in(mem_write_id), .mem_read_in(mem_read_id),
        .mem_to_reg_in(mem_to_reg_id), .reg_write_in(reg_write_id),
        .rd_addr_in(rd_addr_id), .rs1_addr_in(rs1_addr), .rs2_addr_in(rs2_addr),

        .rs1_data_out(rs1_data_ex), .rs2_data_out(rs2_data_ex),
        .sign_ext_value_out(sign_ext_value_ex), .pc_current_out(pc_current_ex),
        .alu_op_out(alu_op_ex), .func3_out(func3_ex), .func7_bit30_out(func7_bit30_ex),
        .alu_src_out(alu_src_ex), .branch_out(branch_ex),
        .mem_write_out(mem_write_ex), .mem_read_out(mem_read_ex),
        .mem_to_reg_out(mem_to_reg_ex), .reg_write_out(reg_write_ex),
        .rd_addr_out(rd_addr_ex), .rs1_addr_out(rs1_addr_out), .rs2_addr_out(rs2_addr_out)
    );

    // ============ Hazard Detection Unit ============
    hazard_detection_unit hazard_unit (
        .mem_read_ex(mem_read_ex), .rd_addr_ex(rd_addr_ex),
        .rs1_addr_id(rs1_addr), .rs2_addr_id(rs2_addr),
        .stall(stall)
    );

    // ============ Forwarding Unit ============
    wire [1:0] forward_a, forward_b;
    forwarding_unit fwd_unit (
        .rs1_addr_ex(rs1_addr_out), .rs2_addr_ex(rs2_addr_out),
        .rd_addr_mem(rd_addr_mem), .reg_write_mem(reg_write_mem),
        .rd_addr_wb(rd_addr_wb), .reg_write_wb(reg_write_wb),
        .forward_a(forward_a), .forward_b(forward_b)
    );

    wire [WIDTH-1:0] alu_operand_a_forwarded;
    assign alu_operand_a_forwarded = (forward_a == 2'b01) ? alu_result_mem :
                                      (forward_a == 2'b10) ? wr_data_wb :
                                      rs1_data_ex;

    wire [WIDTH-1:0] rs2_data_ex_forwarded;
    assign rs2_data_ex_forwarded = (forward_b == 2'b01) ? alu_result_mem :
                                    (forward_b == 2'b10) ? wr_data_wb :
                                    rs2_data_ex;

    // ============ EX stage ============
    wire [3:0] alu_control_ex;
    alu_control_unit alu_con_unit (
        .alu_op(alu_op_ex), .func3(func3_ex), .func7_bit30(func7_bit30_ex),
        .alu_control(alu_control_ex)
    );

    wire [WIDTH-1:0] alu_operand_b_ex;
    assign alu_operand_b_ex = alu_src_ex ? sign_ext_value_ex : rs2_data_ex_forwarded;

    wire [WIDTH-1:0] alu_result_ex;
    wire is_zero_ex;
    alu #(.WIDTH(WIDTH)) alu_inst (
        .operand_a(alu_operand_a_forwarded), .operand_b(alu_operand_b_ex),
        .alu_control(alu_control_ex),
        .result(alu_result_ex), .is_zero(is_zero_ex)
    );

    assign branch_target_addr = pc_current_ex + sign_ext_value_ex;
    assign branch_taken = branch_ex & is_zero_ex;

    assign flush    = branch_taken;
    assign ex_flush = branch_taken | stall;

    // ============ EX/MEM register ============
    ex_mem_reg ex_mem_reg_inst (
        .clk(clk), .reset(reset), .stall(1'b0), .flush(1'b0),

        .alu_result_in(alu_result_ex), .rs2_data_in(rs2_data_ex),
        .mem_write_in(mem_write_ex), .mem_read_in(mem_read_ex),
        .mem_to_reg_in(mem_to_reg_ex), .reg_write_in(reg_write_ex),
        .rd_addr_in(rd_addr_ex),

        .alu_result_out(alu_result_mem), .rs2_data_out(rs2_data_mem),
        .mem_write_out(mem_write_mem), .mem_read_out(mem_read_mem),
        .mem_to_reg_out(mem_to_reg_mem), .reg_write_out(reg_write_mem),
        .rd_addr_out(rd_addr_mem)
    );

    // ============ MEM stage ============
    wire [WIDTH-1:0] read_data_mem;
    data_mem #(.WIDTH(WIDTH)) data_memr (
        .clk(clk), .mem_write(mem_write_mem), .mem_read(mem_read_mem),
        .addr(alu_result_mem), .write_data(rs2_data_mem),
        .read_data(read_data_mem)
    );

    // ============ MEM/WB register ============
    mem_wb_reg mem_wb_reg_inst (
        .clk(clk), .reset(reset), .stall(1'b0), .flush(1'b0),

        .read_data_in(read_data_mem), .alu_result_in(alu_result_mem),
        .mem_to_reg_in(mem_to_reg_mem), .reg_write_in(reg_write_mem),
        .rd_addr_in(rd_addr_mem),

        .read_data_out(read_data_wb), .alu_result_out(alu_result_wb),
        .mem_to_reg_out(mem_to_reg_wb), .reg_write_out(reg_write_wb),
        .rd_addr_out(rd_addr_wb)
    );

    // ============ WB stage ============
    assign wr_data_wb = mem_to_reg_wb ? read_data_wb : alu_result_wb;

endmodule
