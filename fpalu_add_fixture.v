`include "fpalu_add.v"

module fpalu_add_fixture;
reg [31:0]a,b;
wire [31:0]s;
//wire overflow;

initial
$vcdpluson;

initial
$monitor($time," A=%h B=%h S=%h /*overflow=%b*/",a,b,s/*overflow*/);

fpalu_add a1(a,b,s/*overflow*/);

initial

begin

a= 32'h0deeee00 ; b= 32'h0dee0000;
#20 a=32'hf5550005 ; b= 32'h7555000d;
#20 a=32'hc0ffffff ; b= 32'h40ffffff;
#20 a=32'hd5551255 ; b= 32'hd5551250;

#100 $finish;
end
endmodule
