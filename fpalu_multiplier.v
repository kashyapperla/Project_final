
module fpalu_multiplier(Ain,Bin,product);
input [32:0]Ain,Bin; 
output reg [31:0]product;
//input clk;
reg sign;
reg [8:0]exp,fexp1,fexp2;
reg flag;
//for internal computations
reg [23:0]a,b;
reg [47:0]s,sum;
reg [24:0]sum1,sum2;

reg flag7[0:31];
integer i=0;
/*
always @(posedge clk)
begin
Ain<=32'h0000_0000;
Bin<=32'h0000_0000; 
end*/

always @(*)
	begin
	//if(start)

	exp =Ain[30:23]+Bin[30:23]-8'd127; //Adding exponents of the two inputs and subtracting the bias to get new biased exponent
	
		if(exp>= 0 && exp <=255)//
			begin
			a={1'b1,Ain[22:0]};
                    	b={1'b1,Bin[22:0]};
                    	sign=Ain[31]^Bin[31];
                    	flag=1'b0;
			end
		else 
			begin 
 			a=24'd0;
                    	b=24'd0;
                    	exp=9'd0;
                    	sign=1'b0;
                    	flag=1'b1; 
			end 

s=a*b;


	if(s[47])
		begin
		sum=s>>1;
		fexp1=exp+1'b1;

		if(fexp1[8])
                    begin

                        flag=1'b1;  

                    end                
		         begin   
			        if(sum[22]==1'b1)
			                begin
				            sum1=sum[47:23]+1'b1;
				        end 
				else
				        begin
				            sum1=sum[47:23];
				        end

		        end
		end
	else 
	    begin
                sum=s;
                fexp1=exp; 
	                /*if(fexp1[8])
		                    begin
		                        flag=1'b1;     
		                    end
					begin 
						if(sum[22]==1'b1)
					            begin
						            sum1=sum[47:23]+1'b1;
					            end 
						else
					            begin
						            sum1=sum[47:23];
					            end 
					end*/
	end

	if(sum1[24]==1'b1)
	    begin
		sum2=sum1>>1;
		fexp2=fexp1+1'b1;
			if(fexp2[8])
			    begin
				  flag=1'b1;     
		    		end
	    end
	else
            begin
		sum2=sum1;
                fexp2=fexp1;    
	                if(fexp2[8])
		                    begin
		                        flag=1'b1;        
		                    end
            end

product={sign,fexp2[7:0],sum2[22:0]};
end 
endmodule
