`include "fpalu.v"

module fpalu_fixture;
reg [31:0]a,b;
reg op,clk,rst;
wire [31:0]s,o1,o2;
wire o,f1,f2;

initial
$vcdpluson;

initial
$monitor($time," A=%h B=%h op=%b clk=%b rst=%b S=%h overflow=%b",a,b,op,clk,rst,s,o);

fpalu a1(a,b,op,clk,rst,s,o1,o2,o,f1,f2);

initial

begin

clk=1;rst=0;
#20 a= 32'h0deeee00 ; b= 32'h0dee0000; op=0; clk=1; rst=1;
#20 a=32'hf5550005 ; b= 32'h7555000d; op=1; clk=1; rst=1;
#20 a=32'hfee30099 ; b= 32'h7de00090; op=0; clk=1; rst=1;
#20 a=32'hd5551255 ; b= 32'hd5551250; op=1; clk=1; rst=1;

#100 $finish;
end
endmodule
