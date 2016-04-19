`include "fpalu_add.v"

module fpalu_add_fixture;
reg [31:0]a,b;
wire [31:0]s;

initial
$vcdpluson;

initial
$monitor($time," A=%h B=%h S=%h",a,b,s);

fpalu_add a1(a,b,s);

initial

begin

a= 32'h0deeee00 ; b= 32'h0dee0000;
#20 a=32'hd5550005 ; b= 32'hd555000d;
#20 a=32'h7ee00099 ; b= 32'h7ed00090;

#20 $finish;
end
endmodule
