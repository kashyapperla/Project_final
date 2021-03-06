`include "fpalu.v"
`include "verify.v"

module fpalu_fixture;
reg [31:0]a,b;
reg op,clk,rst;

wire [31:0]out1;
//wire [31:0]out2;
wire o1;
//wire o2;

integer data_a    ; // file handler

integer               err    ; // file handler


initial

         begin

                 clk = 0;

                 forever #10 clk=~clk;

         end  

   
initial
    $vcdpluson;
  
fpalu a1(a,b,op,clk,rst,out1,o1);
//fpalu A6(.A(a),.B(b),.clock(clk),.reset(rst),.op(op),.Result(out1),.overflow(o1));
//verify A8(.a_in(a),.b_in(b),.clk(clk),.reset(rst),.op(op),.Result(out2),.overflow(o2));


initial 
begin
op = 0;
forever #20 op=~op;
end 
    
initial 
begin
rst = 0;
data_a = $fopen("rega.txt", "r");

while(!$feof(data_a))
begin


#20 rst = 1'b1;
@(posedge clk);
       rst = 1'b0;
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
//$display("out2: %h",out2);      
$display("out1: %h",out1);
end
//$display("A:%h",A);   

/*  $display("Expected result,Expected overflow:\t%h %b",out2,o2);
$display("Actual result, Actual overflow:\t%h %b",out1,o1);

if(out1 == out2)
$display("PASS");
else if((o1 == 1) && (o2 == 1))
$display("PASS");
else
$display("FAIL");
*/



end





$fclose(data_a);

#200 $finish;
end
endmodule
