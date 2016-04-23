`include "fpalu_multiplier.v"

module fpalu_multiplier_fixture;
reg [32:0]a,b;
wire [31:0]product;
reg clk;

initial 
//begin
$vcdpluson;

initial 
$monitor($time, "A=%h B=%h P=%h",a,b,product);

fpalu_multiplier f1(a,b,product);
//initial
//begin
//$readmemh("reg_a.dat",a);
//$readmemh("reg_b.dat",b);


initial

begin

a= 32'h0deeee00; b=32'h0dee0000;
#20 a= 32'h40d00000; b=32'h41400000;
#20 a= 32'hc0c00000; b=32'h41400000;


#800 $finish;

end 
endmodule
