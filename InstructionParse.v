/* Module designed to read the instruction and assign the various
components of the instruction to suitable variables depending on the format
*/

module InstructionParse (
    output wire [5:0] opcode,
    output reg [4:0] rs,rt,rd,bo,bi,
    output reg [8:0] xoxo,
    output reg [9:0] xox,
    output reg rc,aa,lk,oe,
    output reg [13:0] bd,ds,
    output reg [15:0] si,
    output reg [23:0] li,
    output reg [1:0] xods,
    input [31:0] instructionRev
);
reg [0:31] instruction;
assign opcode = instructionRev[31:26];

always @(instruction)
 begin
    assign instruction = instructionRev;
    
     if(opcode == 6'd31 & (instruction[22:30] == 9'd266 | instruction[22:30] == 9'd40) )
      begin
          xoxo = instruction[22:30];
          rd = instruction[6:10];
          rs = instruction[11:15];
          rt = instruction[16:20];
          oe = instruction[21];
          rc = instruction[31];
      end
      else if(opcode == 6'd31)
      begin
         xox = instruction[21:30];
         rc = instruction[31];
         rd = instruction[6:10];
         rs = instruction[11:15];
         rt = instruction[16:20];
      end
      else if(opcode ==  6'd14 | opcode == 6'd15 | opcode == 6'd28 |opcode == 6'd24 |opcode == 6'd26 |opcode == 6'd32 |opcode == 6'd36 |opcode == 6'd37 |opcode == 6'd40 | opcode == 6'd42 |opcode == 6'd44 |opcode == 6'd34 |opcode == 6'd38 )
       begin
           rd = instruction[6:10];
           rs = instruction[11:15];
           si = instruction[16:31];
       end   // if bclr to be used, add it
      else if(opcode == 6'd19)
       begin
         bo = instruction[6:10];
         bi = instruction[11:15];
         aa = instruction[30];
         lk = instruction[31];
         bd = instruction[16:29];
       end
      else if(opcode == 6'd18)
      begin
          li = instruction[6:29];
          aa = instruction[30];
          lk = instruction[31];
      end
      else 
       begin
        rd = instruction[6:10];
        rs = instruction[11:15];
        ds = instruction[16:29];
        xods = instruction[30:31];
      end
 end
endmodule