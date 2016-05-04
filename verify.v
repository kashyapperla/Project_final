module verify(a_in,b_in,clk,reset,op,Result,overflow);
input clk,reset;
input[31:0]a_in,b_in;
input op;
output reg [31:0]Result;
//reg [31:0]out;
output reg overflow = 1'b0;

reg[31:0]a,b;
reg[25:0]asig,bsig,sig;
reg[8:0]aexp,bexp,exp,fexp1,fexp2;
reg asign,bsign,sign;
reg[7:0] shift;
reg [47:0]s,sum;
reg [24:0]sum1,sum2;
reg flag;
integer i,x,y;

always@(posedge clk or negedge reset)
begin
//if (reset==0)
//Result <= 0;
 if (reset)

Result <= Result;
end


always@(*)
begin
if ( a_in[30:23] < b_in[30:23] ) 
 begin
 a = b_in;  
 b = a_in;
 end 
 else 
 begin
 a = a_in;  
 b = b_in;
 end
//split the value of a,b into sign(sign), exponent(exp), and significand(sig).

//asign = signbit of a, bsign = signbit of b
  asign = a[31];     bsign = b[31];

//aexp is exponent part of a, bexp is exponent part of b
aexp = a[30:23];  bexp = b[30:23];

        asig = {1'b1,a[22:0]};
        bsig = {1'b1,b[22:0]};



//if(aexp == 0 || aexp == 255 || bexp == 0 || bexp == 255) overflow = 1'b1;

case (op)

//1'b0 : add_task();

//1'b1 : multi_task();

//endcase


//add and multiply tasks
//task add_task();
1'b0 :
begin

//de-normalize b so that aexp == bexp.

shift = aexp - bexp;
bsig = bsig >> shift;

if(aexp == 0 || aexp == 255) overflow = 1'b1;
else overflow = 1'b0;

 exp = aexp;
if (asign == bsign) 
        begin
          sig = asig + bsig;
          sign = asign;
        end 
else 
      begin
          if (asig > bsig) 
           begin
            sig = asig - bsig;
            sign = asign;
            end 
          else 
           begin
            sig = bsig - asig;
            sign = bsign;
           end
     end

//normalization
if(sig[23]) 
  begin
 //Sum overflow.
      exp = aexp + 1;
      sig = sig >> 1;

      end
 else
 begin
      //not a overflow.
	 

// Find position of first non-zero digit.
       for (i = 22 ; i >= 0; i = i - 1 ) 
           begin

	   if ( !x && sig[i] )
           begin 
            x = i;
 // Compute amount to shift significand and reduce exponent.
           y = 22 - x;

    if (y == 22) 
    
    begin
           exp = 9'b0 ; sign = 1'b0;
    end    

    if ( aexp > y)
 //  Exponent too small, floating point underflow, set to zero.
 
   begin
              

              exp = aexp - y;
              sig = sig << y;

    end

    end 

end 

end

//the output format assign statements
Result[31] = sign;
Result[30:23] = exp[7:0];
Result[22:0] = sig; 

end
//endtask

//task multi_task();
1'b1 :
begin
	//if(start)

	fexp1 =aexp+bexp-8'd127; //Adding exponents of the two inputs and subtracting the bias to get new biased exponent
	
		//if(fexp1> 0 && fexp1 <255)
                    	//sign= asign^bsign;
if(fexp1> 0 && fexp1 <255)
			begin
			sign=asign^bsign;
                    	overflow=1'b0;
			end
		else 
			begin 
 			
                    	overflow=1'b1; 
			end 
        
//changed a to asig and b to bsig
s=asig*bsig;


	if(s[47])
		begin
		sum=s>>1;
		fexp2=fexp1+1'b1;

		if(fexp2[8])
                    begin

                        overflow=1'b1;  

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
                fexp2=fexp1; 
	                
	end

	if(sum1[24]==1'b1)
	    begin
		sum2=sum1>>1;
		exp=fexp2+1'b1;
			if(exp[8])
			    begin
				  overflow=1'b1;     
		    		end
	    end
	else
            begin
		sum2=sum1;
                exp=fexp2;    
	                if(exp[8])
		                    begin
		                        overflow=1'b1;        
		                    end
            end

Result={sign,exp[7:0],sum2[22:0]};

end 
//endtask
endcase
end
endmodule


