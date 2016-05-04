`include "fpalu.v"
`include "verify.v"

module top_fixture;
reg [31:0]a,b;
reg op,clk,rst;

wire [31:0]out1;
wire [31:0]out2;
wire o1;
wire o2;
reg flag6;
integer i;
integer j=32;
integer data_a    ; // file handler

integer               err    ; // file handler


initial

         begin

                 clk = 0;

                 forever #5 clk=~clk;

         end  

   
initial
    $vcdpluson;
  

fpalu A6(.A(a),.B(b),.clock(clk),.reset(rst),.op(op),.Result(out1),.overflow(o1));
verify A8(.a_in(a),.b_in(b),.clk(clk),.reset(rst),.op(op),.Result(out2),.overflow(o2));


initial 
begin
op = 0;
forever #10 op=~op;
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
          $display("a:\t%h",a);
          $display("b:\t%h",b);
$display("op:\t%b",op);
        $display("Expected result,o2:\t%h %b",out2,o2);
$display("Actual result, o1:\t%h %b",out1,o1);

if(out1 == out2)
$display("PASS");
else if((o1 == 1) && (o2 == 1))
$display("PASS");
else
$display("FAIL");

end


end





$fclose(data_a);

 $finish;
end
endmodule
