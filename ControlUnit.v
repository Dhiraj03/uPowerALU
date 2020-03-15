

module control_unit (
    output reg RegRead,
               RegWrite,
               MemRead,
               MemWrite,
               Branch,
    input [5:0] opcode,
    input [8:0] xoxo,
    input [9:0] xox,
    input [1:0] xods
);

always @(opcode, xoxo, xox, xods)
  begin
      //RESET TO 0
      MemRead = 1'b0;
      MemWrite = 1'b0;
      RegWrite = 1'b0;
      RegRead = 1'b0;
      Branch = 1'b0;
      
      //XO 
      if(opcode == 6'd31 & xoxo != 0)
        begin
            RegRead = 1'b1;
            RegWrite = 1'b1;
        end
      
      //X
      else if(opcode == 6'd31 & xox != 0) //X
        begin
            RegRead = 1'b1;
            RegWrite = 1'b1;
        end

        //D-ALU Instructions
      else if(opcode ==  6'd14 | opcode == 6'd15 | opcode == 6'd28 |opcode == 6'd24 |opcode == 6'd26) //D-ALU instructions
        begin
            RegRead = 1'b1;
            RegWrite = 1'b1;
        end

        //D-Load Instructions
      else if(opcode == 6'd32 |opcode == 6'd40 | opcode == 6'd42 |opcode == 6'd34 | opcode == 6'd58) 
        begin
            RegRead = 1'b1;
            RegWrite = 1'b1;
            MemRead = 1'b1;
        end

        //D-Store Instructions
      else if(opcode == 6'd36 | opcode == 6'd37 | opcode == 6'd44 | opcode == 6'd38 | opcode == 6'd62) 
        begin
            RegRead = 1'b1;
            MemWrite = 1'b1;
        end

        //Unconditional Branch
      else if(opcode == 6'd18)
        begin
            Branch = 1'b1;
        end

        //Conditional Branch
      else if(opcode == 6'd19)
        begin
            RegRead = 1'b1;
            Branch = 1'b1;
        end      
  end
  
endmodule