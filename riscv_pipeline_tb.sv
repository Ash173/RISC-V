`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 12.08.2026 21:03:12
// Design Name: 
// Module Name: riscv_pipeline_tb
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
module tb_riscv_pipeline;

    reg clk;
    reg reset;

    riscv_pipeline #(.WIDTH(32)) dut (
        .clk(clk), .reset(reset)
    );

    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

    initial begin
        // ---- Program ----
        // addr 0 : lw  x1, 0(x0)        x1 = mem[0] = 10
        // addr 4 : add x3, x1, x1        x3 = 20   (LOAD-USE HAZARD: x1 used immediately after lw -> stall test)
        // addr 8 : sub x4, x3, x3        x4 = 0    (ALU-ALU HAZARD: x3 forwarded from EX/MEM)
        // addr 12: add x5, x4, x3        x5 = 20   (x4 forwarded from EX/MEM, x3 forwarded from MEM/WB)
        // addr 16: beq x0, x0, 8         always taken -> skip addr 20, jump to addr 24
        // addr 20: add x6, x0, x0        should be SKIPPED (x6 stays untouched/x)
        // addr 24: sub x7, x5, x4        should EXECUTE, x7 = 20

        dut.imem_inst.instr_mem[0] = 8'h83;
        dut.imem_inst.instr_mem[1] = 8'h20;
        dut.imem_inst.instr_mem[2] = 8'h00;
        dut.imem_inst.instr_mem[3] = 8'h00;
        dut.imem_inst.instr_mem[4] = 8'hb3;
        dut.imem_inst.instr_mem[5] = 8'h81;
        dut.imem_inst.instr_mem[6] = 8'h10;
        dut.imem_inst.instr_mem[7] = 8'h00;
        dut.imem_inst.instr_mem[8] = 8'h33;
        dut.imem_inst.instr_mem[9] = 8'h82;
        dut.imem_inst.instr_mem[10] = 8'h31;
        dut.imem_inst.instr_mem[11] = 8'h40;
        dut.imem_inst.instr_mem[12] = 8'hb3;
        dut.imem_inst.instr_mem[13] = 8'h02;
        dut.imem_inst.instr_mem[14] = 8'h32;
        dut.imem_inst.instr_mem[15] = 8'h00;
        dut.imem_inst.instr_mem[16] = 8'h63;
        dut.imem_inst.instr_mem[17] = 8'h04;
        dut.imem_inst.instr_mem[18] = 8'h00;
        dut.imem_inst.instr_mem[19] = 8'h00;
        dut.imem_inst.instr_mem[20] = 8'h33;
        dut.imem_inst.instr_mem[21] = 8'h03;
        dut.imem_inst.instr_mem[22] = 8'h00;
        dut.imem_inst.instr_mem[23] = 8'h00;
        dut.imem_inst.instr_mem[24] = 8'hb3;
        dut.imem_inst.instr_mem[25] = 8'h83;
        dut.imem_inst.instr_mem[26] = 8'h42;
        dut.imem_inst.instr_mem[27] = 8'h40;

        // ---- data_mem: mem[0] = 10 ----
        dut.data_memr.data_memr[0] = 8'h0A;
        dut.data_memr.data_memr[1] = 8'h00;
        dut.data_memr.data_memr[2] = 8'h00;
        dut.data_memr.data_memr[3] = 8'h00;

        reset = 1;
        #10;
        reset = 0;

        #250;

        $display("---------------------------------------------");
        $display("x1 = %0d (expect 10)", dut.r_file.register_file[1]);
        $display("x3 = %0d (expect 20)", dut.r_file.register_file[3]);
        $display("x4 = %0d (expect 0)",  dut.r_file.register_file[4]);
        $display("x5 = %0d (expect 20)", dut.r_file.register_file[5]);
        $display("x6 = %0d (expect x/untouched -- proves branch flush worked)", dut.r_file.register_file[6]);
        $display("x7 = %0d (expect 20, proves PC correctly jumped to addr 24)", dut.r_file.register_file[7]);
        $display("---------------------------------------------");

        $finish;
    end

    initial begin
        $monitor("t=%0t pc=%0d instr_id=%h stall=%b flush=%b ex_flush=%b forward_a=%b forward_b=%b rd_wb=%0d wr_data_wb=%0d reg_write_wb=%b",
            $time, dut.pc_current, dut.instr_if_id_out, dut.stall, dut.flush, dut.ex_flush,
            dut.forward_a, dut.forward_b, dut.rd_addr_wb, dut.wr_data_wb, dut.reg_write_wb);
    end

endmodule
