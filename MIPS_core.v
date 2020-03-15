/* uPowerISA Core Module is the centre of all operations that handles all the operations and instantiates
all the necessary modules
*/
`include "ControlUnit.v"
`include "InstructionParse.v"
`include "ALU32bit.v"
`include "ReadInstructions.v"
`include "ReadMem.v"
`include "ReadRegisters.v"

module mips_core(clock);

input clock; //Execution happens only at positive level-transition (edge sensitive)

//Program counter

reg [31:0] PC = 32'b0;

//Instruction
wire [31:0] instruction;

//Parse instruction
wire [5:0] opcode;
wire [4:0] rs,rt,rd,bo,bi;
wire [8:0] xoxo;
wire [9:0] xox;
wire rc,aa,lk,oe;
wire [13:0] bd,ds;
wire [15:0] si;
wire [23:0] li;
wire [1:0] xods;

//Signals

wire RegRead, RegWrite, MemRead, MemWrite, Branch;

//Register contents
wire [63:0] write_data, rs_content, rt_content, memory_read_data;

//Instantiating all necessary modules
read_instructions InstructionMemory(instruction, PC);

InstructionParse Parse(opcode, rs, rt, rd, bo, bi,xoxo,xox,rc,aa,lk,oe,si,li,xods,instruction);

control_unit Signals(RegRead, RegWrite, MemRead, MemWrite, Branch, opcode, xoxo, xox, xods);

ALU32bit ALU(write_data, Branch, rs, rt, bo, bi, opcode, xoxo, xox, rc, ds, si, xods);

read_mem MainMemory(memory_read_data, write_data, rs_content, opcode, MemRead, MemWrite);

read_registers Registers(rs_content, rt_content, rs,rt,rd, opcode, write_data, RegRead, RegWrite);

// PC operations - The next instruction is read only when the clock is at positive edge

always @(posedge clock) 
 begin
     if(opcode == 6'd18)
       PC = {8{1'b0},li};
     else if(write_data == 0 & Branch == 1)
       PC = PC + 1 + $signed(bd);
     else 
       PC = PC +1 ;
 end


endmodule

