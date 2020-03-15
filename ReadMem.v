/* Module designed to read and write to the main memory
*/

module read_mem(
output reg [63:0] ReadData,
input [63:0] address,
input [63:0] WriteData,
input [5:0] opcode,
input MemRead, MemWrite
);

reg [63:0] data_mem [4:0];
initial 
begin
    $readmemb("data.mem",data_mem, 4,0);
end
always @(address)
  begin
      if(MemWrite) 
       begin
           if(opcode == 6'd38)
             begin
                 data_mem[address] = {{56{1'b0}}, WriteData[7:0]};
             end
           if(opcode == 6'd44)
             begin
                 data_mem[address] = {{48{1'b0}}, WriteData[15:0]};
             end
           if(opcode == 6'd36)
             begin
                 data_mem[address] = {{32{1'b0}}, WriteData[31:0]};
             end
           if(opcode == 6'd62)
             begin
                 data_mem[address] = WriteData;
             end
            $writememb("data.mem",data_mem);
       end
  end

always @(address)
 if(MemRead)
  begin
      ReadData = data_mem[address];
  end

endmodule
