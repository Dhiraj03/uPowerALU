/* Test Module designed to read the instructions from a .mem file containing the 32-bit MIPS instructions
in binary
*/
module read_instructions;
output reg [31:0] instruction;
input [31:0] program_counter;
reg [31:0] instructions [5:0];  //set according to use

initial
  begin
    program_counter = 0;
    $readmemb("instructions.mem",instructions,5,0);
  end

always @(program_counter)
  begin
    instruction = instructions[program_counter];
  end

endmodule


