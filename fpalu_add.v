module fpalu_add(a_input,b_input,sum);
input[31:0]a_input,b_input;
output[31:0]sum;

reg sumneg;//the sign bit is represented as neg
reg[7:0] sumexp =0;
reg[24:0] sumsig=0;
reg[31:0]sum=0;


//for internal computations
reg[31:0]a,b;
reg[24:0]asig,bsig;
reg[7:0]aexp,bexp;
reg aneg,bneg;
reg[7:0] shift;
integer pos = 0, val, i;

//Compare exponents and swap the values for computation
 always @(*) 
 begin
//Compare exponents
 if ( a_input[30:23] < b_input[30:23] ) 
 begin
 a = b_input;  b = a_input;
 end 
 else 
 begin
 a = a_input;  b = b_input;
 end
//split the value of a,b into sign(neg), exponent(exp), and significand(sig).

//aneg = signbit of a, bneg = signbit of b
  aneg = a[31];     bneg = b[31];

//aexp is exponent part of a, bexp is exponent part of b
aexp = a[30:23];  bexp = b[30:23];

        asig = {1'b1,a[22:0]};
        bsig = {1'b1,b[22:0]};

//de-normalize b so that aexp == bexp.

shift = aexp - bexp;
bsig = bsig >>shift;

 //negate the significands.
 if ( aneg )
 asig = (~{aneg,asig}) + 1'b1;
 else
 asig = {1'b0,asig};
 if ( bneg ) 
 bsig = (~{bneg,bsig}) + 1'b1;
 else
 bsig = {1'b0,bsig};

 //Sum calculation
 sumsig = asig + bsig;
 
 //Take absolute value of sum.
 sumneg = sumsig[24];
 if ( sumneg ) sumsig = (~sumsig) + 1'b1;
 
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
       for (i = 23; i >= 0; i = i - 1 ) 
           begin

	   if ( !pos && sumsig[i] )
           begin 
            pos = i;
 // Compute amount to shift significand and reduce exponent.
           val = 23 - pos;
    if ( aexp > val)
 //  Exponent too small, floating point underflow, set to zero.
 
   begin
              

              sumexp = aexp - val;
              sumsig = sumsig << val;

    end

    end 

end 

end

//the output format assign statements
sum[31] = sumneg;
sum[30:23] = sumexp;
sum[22:0] = sumsig; 


end

endmodule
