module rand();

integer i,j;
integer fpr1,fpr2;

initial

begin

fpr1=$fopen("rega.txt","w");

fpr2=$fopen("regb.txt","w");

for(i=0;i<32;i=i+1)

begin

$fdisplay(fpr1,"%h %h",$random(),$random());

end

$fclose(fpr1);

/*for(j=0;j<32;j=j+1)

begin

$fdisplay(fpr2,"%h",$random());

end
$fclose(fpr2);
*/
end

endmodule


