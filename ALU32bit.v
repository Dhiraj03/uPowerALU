/* Module designed to act as the ALU - takes in the opcode, contents of the registers, shiftAmount, ALUResult and AluSrc signals
with the signedImm as arguments
*/

module ALU32bit(
  output reg [63:0] ALU_result,
  output reg Branch,
  input [63:0] rs,rt,bo,bi, 
  input [5:0] opcode,
  input [8:0] xoxo, //to identify whether ADD or SUB
  input [9:0] xox,  
  input rc,aa, 
  input [13:0] ds, //bd is used for branch
  input [15:0] si,
  //input [23:0] li,
  input [1:0] xods
);

integer i;
reg signed [31:0] temp, signed_rs, signed_rt; 
reg [31:0] signExtend, zeroExtend, signExtendSI, sign16ExtendSI, signExtendDS;
always @(rs,rt,bo,bi,xox,xoxo,xods,rc,ds,si)
  begin
      signed_rs = rs;
      signed_rt = rt;
      signExtendSI = {{48{si[15]}},si};
       sign16ExtendSI = {si,{16{si[15]}}};
       signExtendDS = {{50{ds[13]}}, ds};
      if(opcode == 6'd31 & xoxo!= 0)
        begin
            case(xoxo) 
              
              9'd266 : //ADD
                ALU_result = signed_rs + signed_rt;
              
              9'd40 : //SUB
                ALU_result = signed_rt - signed_rs;
            endcase
        end
      else if (opcode == 6'd31)
        begin
            case(xox)
              
              10'd28: //AND
               ALU_result = rs & rt;
              
              10'd986: //EXTSW
               ALU_result = {{32{rs[31]}}, rs[31:0]};
              
              10'd476: //NAND
               ALU_result = ~(rs & rt);
             
              10'd444 : //OR
               ALU_result = rs | rt;
             
              10'd316 : //XOR
               ALU_result = rs ^ rt;
            
            endcase       
        end

else if(opcode ==  6'd14 | opcode == 6'd15 | opcode == 6'd28 |opcode == 6'd24 |opcode == 6'd26 |opcode == 6'd32 |opcode == 6'd36 |opcode == 6'd37 |opcode == 6'd40 | opcode == 6'd42 |opcode == 6'd44 |opcode == 6'd34 |opcode == 6'd38 )
      begin
          case(opcode) 
          6'd14 : //ADDI
            ALU_result = signExtendSI + rs;
          6'd15 :  //ADDIS
           ALU_result = sign16ExtendSI + rs;
          6'd28 : //ANDI
           ALU_result = signExtendSI & rs;
          6'd24 : //ORI
           ALU_result = signExtendSI | rs;
          6'd26: //XORI
           ALU_result = signExtendSI ^ rs;

          6'd32: // LWZ
           ALU_result = signed_rs + signExtendSI;  //ADDRESS IN MAIN MEMORY
          6'd36 : 
           ALU_result = signed_rs + signExtendSI;
          6'd37 : 
           ALU_result = signed_rs + signExtendSI;
          6'd40 : 
           ALU_result = signed_rs + signExtendSI;
          6'd42 : 
           ALU_result = signed_rs + signExtendSI;
          6'd44 : 
           ALU_result = signed_rs + signExtendSI;
          6'd36 : 
           ALU_result = signed_rs + signExtendSI;
          6'd36 : 
           ALU_result = signed_rs + signExtendSI;
        endcase
      end
else if(opcode == 6'd18) 
    begin
        Branch = 1;   
    end
else if(opcode == 6'd19)
    begin
        if (aa == 1'b0) // BEQ
          begin
          ALU_result = signed_rs - signed_rt;
          if(ALU_result == 0)
            Branch = 1;
          else  
            Branch = 0;
          end
        else 
          begin
          ALU_result = signed_rs - signed_rt;
          if(ALU_result == 0)
            begin
            Branch = 0;
            ALU_result = 0;  // check later
            end
          else 
            Branch = 1;
          end
    end
else if(opcode == 6'd58)
   ALU_result = signed_rs + signExtendDS;
else if(opcode == 6'd62)
   ALU_result = signed_rs + signExtendDS;


end


initial 
begin
    $monitor("Opcode : %6b, RS : %b, RT : %b, signExtendImm = %b, signExtendDs = %b Result : %b\n",
    opcode, rs, rt, signExtendSI, signExtendDS,ALU_result);
end

endmodule

