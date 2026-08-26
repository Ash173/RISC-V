`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 11.08.2026 22:35:32
// Design Name: 
// Module Name: risc_single_cycle_test
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


`timescale 1ns/1ps

module tb_riscv_cpu;

    reg clk;
    reg reset;

    // Instantiate the DUT (Device Under Test)
    risc_v_single_cycle #(.WIDTH(32)) dut (
        .clk(clk),
        .reset(reset)
    );

    // Clock generation - toggle every 5ns => 10ns period (100MHz)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

    initial begin
        // ---- Instruction 0: lw x1, 0(x0)   = 0x00002083, addr 0 ----
        dut.instr_mem.instr_mem[0] = 8'h83;
        dut.instr_mem.instr_mem[1] = 8'h20;
        dut.instr_mem.instr_mem[2] = 8'h00;
        dut.instr_mem.instr_mem[3] = 8'h00;

        // ---- Instruction 1: lw x2, 4(x0)   = 0x00402103, addr 4 ----
        dut.instr_mem.instr_mem[4] = 8'h03;
        dut.instr_mem.instr_mem[5] = 8'h21;
        dut.instr_mem.instr_mem[6] = 8'h40;
        dut.instr_mem.instr_mem[7] = 8'h00;

        // ---- Instruction 2: add x3, x1, x2 = 0x002081b3, addr 8 ----
        dut.instr_mem.instr_mem[8]  = 8'hb3;
        dut.instr_mem.instr_mem[9]  = 8'h81;
        dut.instr_mem.instr_mem[10] = 8'h20;
        dut.instr_mem.instr_mem[11] = 8'h00;

        // ---- Instruction 3: sub x4, x1, x2 = 0x40208233, addr 12 ----
        dut.instr_mem.instr_mem[12] = 8'h33;
        dut.instr_mem.instr_mem[13] = 8'h82;
        dut.instr_mem.instr_mem[14] = 8'h20;
        dut.instr_mem.instr_mem[15] = 8'h40;

        // ---- Instruction 4: sw x3, 8(x0)   = 0x00302423, addr 16 ----
        dut.instr_mem.instr_mem[16] = 8'h23;
        dut.instr_mem.instr_mem[17] = 8'h24;
        dut.instr_mem.instr_mem[18] = 8'h30;
        dut.instr_mem.instr_mem[19] = 8'h00;

        // ---- Instruction 5: beq x1, x1, 8  = 0x00108463, addr 20 ----
        dut.instr_mem.instr_mem[20] = 8'h63;
        dut.instr_mem.instr_mem[21] = 8'h84;
        dut.instr_mem.instr_mem[22] = 8'h10;
        dut.instr_mem.instr_mem[23] = 8'h00;

        // ---- Instruction 6: add x5, x0, x0 = 0x000002b3, addr 24 (should be SKIPPED) ----
        dut.instr_mem.instr_mem[24] = 8'hb3;
        dut.instr_mem.instr_mem[25] = 8'h02;
        dut.instr_mem.instr_mem[26] = 8'h00;
        dut.instr_mem.instr_mem[27] = 8'h00;

        // ---- Instruction 7: sub x6, x1, x2 = 0x40208333, addr 28 (should EXECUTE) ----
        dut.instr_mem.instr_mem[28] = 8'h33;
        dut.instr_mem.instr_mem[29] = 8'h83;
        dut.instr_mem.instr_mem[30] = 8'h20;
        dut.instr_mem.instr_mem[31] = 8'h40;

        // ---- data_mem: mem[0] = 10, mem[4] = 3 ----
        dut.data_memr.data_memr[0] = 8'h0A;
        dut.data_memr.data_memr[1] = 8'h00;
        dut.data_memr.data_memr[2] = 8'h00;
        dut.data_memr.data_memr[3] = 8'h00;

        dut.data_memr.data_memr[4] = 8'h03;
        dut.data_memr.data_memr[5] = 8'h00;
        dut.data_memr.data_memr[6] = 8'h00;
        dut.data_memr.data_memr[7] = 8'h00;

        // ---- Apply reset ----
        reset = 1;
        #10;
        reset = 0;

        // ---- Let the program run: 8 instructions, 1 per clock cycle ----
        #150;

        // ---- Check results ----
        $display("x1 = %0d (expect 10)", dut.r_file.register_file[1]);
        $display("x2 = %0d (expect 3)",  dut.r_file.register_file[2]);
        $display("x3 = %0d (expect 13)", dut.r_file.register_file[3]);
        $display("x4 = %0d (expect 7)",  dut.r_file.register_file[4]);
        $display("x5 = %0d (expect 0, should be UNTOUCHED/skipped)", dut.r_file.register_file[5]);
        $display("x6 = %0d (expect 7)",  dut.r_file.register_file[6]);
        $display("mem[8] byte = %0d (expect 13, since 13 fits in one byte)", dut.data_memr.data_memr[8]);

        $finish;
    end

endmodule
