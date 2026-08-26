# RISC-V CPU in SystemVerilog

A from-scratch implementation of a RISC-V processor supporting an 11-instruction RV32I subset, built in two stages: a single-cycle reference design, and a 5-stage pipelined design with data and control hazard handling.

## Instruction Set

| Instruction | Type | Description |
|---|---|---|
| `add`, `sub` | R | Register-register add / subtract |
| `and`, `or`, `xor` | R | Bitwise logic |
| `sll`, `srl`, `sra` | R | Logical/arithmetic shifts |
| `lw` | I | Load word from memory |
| `sw` | S | Store word to memory |
| `beq` | B | Branch if equal |

## Architecture

### 1. Single-Cycle Datapath
A complete single-cycle implementation where every instruction fetches, decodes, executes, accesses memory, and writes back within one clock cycle.

**Modules:** Program Counter, Instruction Memory, Register File, ALU, Immediate Generator, Control Unit, ALU Control Unit, Data Memory.

Verified against a hand-traced test program (`lw`, `add`, `sub`, `sw`, `beq`) with all register and memory values confirmed correct in simulation.

### 2. 5-Stage Pipelined Datapath
The same ISA re-architected into **IF → ID → EX → MEM → WB**, reusing every module from the single-cycle design, connected through four pipeline registers (IF/ID, ID/EX, EX/MEM, MEM/WB).

**Hazard handling:**
- **Data hazards (load-use):** detected by a dedicated Hazard Detection Unit, which stalls the pipeline for one cycle when an instruction needs a register value still in flight from a preceding `lw`.
- **Data hazards (ALU-to-ALU):** resolved via a Forwarding Unit with two bypass paths (EX/MEM and MEM/WB), prioritizing the most recent result, so dependent ALU instructions execute back-to-back without stalling.
- **Control hazards (branches):** resolved in the EX stage; a taken branch flushes the two wrong-path instructions already fetched into IF/ID and ID/EX, and redirects the PC to the correct target.

Verified with a testbench specifically designed to trigger all three hazard types in a single program (load-use stall, EX/MEM forward, MEM/WB forward, and branch flush), with results cross-checked in two independent simulators (Icarus Verilog and Xilinx Vivado).

## Known Limitations

These are explicitly out of scope, not oversights:
- No branch prediction — every taken branch incurs a fixed flush penalty.
- No store-value forwarding — a `sw` immediately following a dependent ALU result is not covered by forwarding.
- No `jal`, `jalr`, `lui`, `auipc`, or immediate-arithmetic (`addi`) instructions.
- No structural hazard handling required — instruction and data memories are separate (Harvard-style), so no contention exists.

## Tools

Designed and simulated in Xilinx Vivado 2023.2 (SystemVerilog), with independent cross-verification in Icarus Verilog.
