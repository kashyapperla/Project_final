`include "fpalu.v"
`include "verify.v"

module fpalu_fixture1;
reg [31:0]a,b;
reg op,clk,rst;
wire [31:0]out1,out2;
wire o1,o2;
integer data_a    ; // file handler

integer               err    ; // file handler

initial

         begin

                 clk = 0;

                 forever #10 clk=~clk;

         end
initial
$vcdpluson;


//$monitor($time," A=%h B=%h op=%b clk=%b rst=%b S=%h overflow=%b",a,b,op,clk,rst,out,o);

fpalu a1(a,b,op,clk,rst,out1,o1);
verify a2(a,b,clk,rst,op,out2,o2);


initial 
begin
op = 0;
forever #15 op=~op;
end 
    
initial 
begin
rst = 0;
data_a = $fopen("rega.txt", "r");

while(!$feof(data_a))
begin


#20 rst = 1'b1;
@(posedge clk);
#20       rst = 1'b0;
        err = $fscanf(data_a,"%h %h\n",a,b);
        if(err != 2)
        begin
          $display("error reading operands, err: %d",err);
          $stop;
        end  
else 
begin
@(posedge clk);
rst = 1'b0;
          $display("a:\t%h",a);
          $display("b:\t%h",b);
$display("op:\t%b",op);
$display("out1: %h",out1);  
$display("out2: %h",out2);     
end
/*
initial

begin
rst = 0;
#20 a= 32'h0deeee00 ; b= 32'h0dee0000; op=0;  rst=1;
#20 a=32'hf5550005 ; b= 32'h7555000d; op=1;  rst=1;
#20 a=32'hfee30099 ; b= 32'h7de00090; op=0;  rst=1;
#20 a=32'hd5551255 ; b= 32'hd5551250; op=1; rst=1;
#20 a=$random ; b= $random; op=0;  rst=1;
#20 a=$random ; b= $random; op=1;  rst=1;
*/
end
$fclose(data_a);
#200 $finish;

end
endmodule
