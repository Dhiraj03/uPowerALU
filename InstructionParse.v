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
    input [31:0] instruction
);
assign opcode = instruction[31:26];

always @(instruction)
 begin
    
    
     if(opcode == 6'd31 & (instruction[9:1] == 9'd266 | instruction[9:1] == 9'd40) )
      begin
          rd = instruction[25:21];
          rs = instruction[20:16];
          rt = instruction[15:11];
          xoxo = instruction[9:1];
          oe = instruction[10];
          rc = instruction[0];
      end
      else if(opcode == 6'd31)
      begin
         xox = instruction[10:1];
         rc = instruction[0];
         rd = instruction[25:21];
         rs = instruction[20:16];
         rt = instruction[15:11];
      end
      else if(opcode ==  6'd14 | opcode == 6'd15 | opcode == 6'd28 |opcode == 6'd24 |opcode == 6'd26 |opcode == 6'd32 |opcode == 6'd36 |opcode == 6'd37 |opcode == 6'd40 | opcode == 6'd42 |opcode == 6'd44 |opcode == 6'd34 |opcode == 6'd38 )
       begin
           rd = instruction[25:21];
           rs = instruction[20:16];
           si = instruction[15:0];
       end  
      else if(opcode == 6'd19)
       begin
         bo = instruction[25:21];
         bi = instruction[20:16];
         aa = instruction[1];
         lk = instruction[0];
         bd = instruction[15:2];
       end
      else if(opcode == 6'd18)
      begin
          li = instruction[25:2];
          aa = instruction[1];
          lk = instruction[0];
      end
      else 
       begin
        rd = instruction[25:21];
        rs = instruction[20:16];
        ds = instruction[15:2];
        xods = instruction[1:0];
      end
 end
endmodule