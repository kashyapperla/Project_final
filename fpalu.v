`include "fpalu_add1.v"
`include "fpalu_multiplier.v"

module fpalu(A,B,op,clock,reset,Result,out1,out2,overflow,flag1,flag2);
input [31:0]A,B;
input op,clock,reset;
output reg [31:0]Result;
output reg overflow;
output [31:0]out1,out2;
output flag1,flag2;
fpalu_add1 f1(.a_in(A),.b_in(B),.sum(out1),.overflow(flag1));
fpalu_multiplier f2(.Ain(A),.Bin(B),.product(out2),.flag(flag2));

always@(posedge clock or negedge reset)
begin
if(!reset)
Result <= 32'b0;
else
Result <= Result;
end



always@(*)
begin
if(op == 1'b0)
begin
Result = out1;
overflow = flag1;
end
else
begin
Result = out2;
overflow = flag2;
end
end


endmodule

