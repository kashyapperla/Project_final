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
parameter idle=2'd0,
add_state=2'd1,
mul_state=2'd2;
reg [1:0]state,next_state;

initial
$display("A:%h",A);

always@(posedge clock or negedge reset)
begin
if(!reset)
state <= idle;
else 
state <= next_state;
end



always@(*)
begin
case(state)
idle : if(op==0)
       next_state = add_state;
       else
       next_state = mul_state;

add_state : if(op==0)
            next_state = add_state;
            else
            next_state = mul_state;

mul_state : if(op==0)
            next_state = add_state;
            else
            next_state = mul_state;
default : next_state = idle;
endcase
end


always@(*)
begin
case(state)
idle : 	    begin
       	    Result = 32'b0;
            overflow = 1'b0;
            end
add_state : begin
            Result = out1;
            overflow = flag1;
            end
mul_state : begin
            Result = out2;
            overflow = flag2;
            end
endcase
end


endmodule

