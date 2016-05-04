module fpalu_add1(a_in,b_in,sum,overflow);
input[31:0]a_in,b_in;
output[31:0]sum;
output reg overflow = 1'b0;

reg sumsign;//the sign bit is represented as neg
reg[7:0] sumexp =0;
reg[25:0] sumsig=0;
reg[31:0]sum=0;

//for internal computations
reg[31:0]a,b;
reg[25:0]asig,bsig,asig1,bsig1;
reg[7:0]aexp,bexp;
reg asign,bsign;
reg[7:0] shift;
integer x = 0, y, i;

//Compare exponents and swap the values for computation
 always @(*) 
 begin
//Compare exponents
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

//de-normalize b so that aexp == bexp.

shift = aexp - bexp;
bsig = bsig >> shift;

if(aexp == 0 || aexp == 255) overflow = 1'b1;


if((asign==bsign)|| ((asign!=bsign)&&(asig>bsig))) sumsign = asign;
else sumsign = bsign;



 

 //negate the significands.
 if ( asign ) asig1 = -asig;
 if ( bsign ) bsig1 = -bsig;

 //Sum calculation

case ({asign,bsign}) 

2'b00 : sumsig = asig + bsig;
2'b01 : sumsig = asig + bsig1;
2'b10 : sumsig = asig1 + bsig;
2'b11 : sumsig = asig + bsig;

endcase

$display("over = %b",overflow);

if (((asig < bsig) && (bsign == 1'b1) && (asign == 1'b0)) || ((bsig < asig) && (asign == 1'b1) && (bsign == 1'b0)))
sumsig = -sumsig;

//normalization
if(sumsig[23]) 
  begin
 //Sum overflow.
      sumexp = aexp + 1;
      sumsig = sumsig >> 1;

      end
 else
 begin
      //not a overflow.
	 

// Find position of first non-zero digit.
       for (i = 22 ; i >= 0; i = i - 1 ) 
           begin

	   if ( !x && sumsig[i] )
           begin 
            x = i;
 // Compute amount to shift significand and reduce exponent.
           y = 22 - x;

    if (y == 22) 
    
    begin
           sumexp = 8'b0 ; sumsign = 1'b0;
    end    

    if ( aexp > y)
 //  Exponent too small, floating point underflow, set to zero.
 
   begin
              

              sumexp = aexp - y;
              sumsig = sumsig << y;

    end

    end 

end 

end

//the output format assign statements
sum[31] = sumsign;
sum[30:23] = sumexp;
sum[22:0] = sumsig; 


end

endmodule
