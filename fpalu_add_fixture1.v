`include "fpalu_add1.v"

module fpalu_add_fixture;
reg [31:0]a,b;
wire [31:0]s;
wire overflow;

initial
$vcdpluson;

initial
$monitor($time,"A=%h B=%h S=%b over=%b",a,b,s,overflow);

fpalu_add1 a1(a,b,s,overflow);

initial

begin

a= 32'b11111111111111111111111111111111; b= 32'b0111111111111111111111111111111;
//#20 a=$random ; b= $random;
//#20 a=$random ; b= $random;
//#20 a=$random ; b= $random;

#100 $finish;
end
endmodule
