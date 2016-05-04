`include "fpalu.v"

module fpalu_fixture;
reg [31:0]a,b;
reg op,clk,rst;
wire [31:0]out;
wire o;

initial

         begin

                 clk = 0;

                 forever #10 clk=~clk;

         end
initial
$vcdpluson;

initial
$monitor($time," A=%h B=%h op=%b clk=%b rst=%b S=%h overflow=%b",a,b,op,clk,rst,out,o);

fpalu a1(a,b,op,clk,rst,out,o);

initial

begin
rst = 0;
#20 a= 32'h0deeee00 ; b= 32'h0dee0000; op=0;  rst=1;
#20 a=32'hf5550005 ; b= 32'h7555000d; op=1;  rst=1;
#20 a=32'hfee30099 ; b= 32'h7de00090; op=0;  rst=1;
#20 a=32'hd5551255 ; b= 32'hd5551250; op=1; rst=1;
#20 a=$random ; b= $random; op=0;  rst=1;
#20 a=$random ; b= $random; op=1;  rst=1;


#20 $finish;
end
endmodule
