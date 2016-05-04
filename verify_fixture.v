`include "verify.v"

module verify_fixture;
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
$monitor($time," A=%h B=%h clk=%b rst=%b op=%b out=%h overflow=%b",a,b,clk,rst,op,out,o);

verify a1(a,b,clk,rst,op,out,o);

initial

begin

rst=0;
#20 a= 32'h0deeee00 ; b= 32'h0dee0000; op=0;  rst=1;
#20 a=32'hf5550005 ; b= 32'h7555000d; op=1; rst=1;
#20 a=32'hfee30099 ; b= 32'h7de00090; op=0; rst=1;
#20 a=32'hd5551255 ; b= 32'hd5551250; op=1; rst=1;

#20 $finish;
end
endmodule
