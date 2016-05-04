`include "fpalu_add1.v"
`include "fpalu_multiplier.v"

module fpalu(A,B,op,clock,reset,Result,overflow);
input [31:0]A,B;
input op,clock,reset;
output reg [31:0]Result;
output reg overflow;
wire [31:0]out1,out2;
reg [31:0]out3;
reg out4;
wire flag1,flag2;
fpalu_add1 f1(.a_in(A),.b_in(B),.sum(out1),.overflow(flag1));
fpalu_multiplier f2(.Ain(A),.Bin(B),.product(out2),.flag(flag2));

always@(posedge clock or negedge reset)
begin
if(!reset)
begin
Result <= 32'b0;
overflow <= 1'b0;
end
else if(reset)
begin
Result <= Result;
//Result <=out3;
overflow <= out4;
end
end



always@(*)
begin
if(op == 1'b0)
begin
//out3 = out1;
Result = out1;
out4 = flag1;
end
else
begin
//out3 = out2;
Result = out2;
out4 = flag2;
end
end


endmodule

