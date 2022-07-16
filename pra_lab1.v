module  pra_lab1(CLOCK_50,KEY1,KEY0,HEX0,HEX1,RST_N);


input CLOCK_50,KEY1,KEY0;
input RST_N;
output [6:0]HEX0;
output [6:0]HEX1;


reg [3:0]a;
reg [3:0]b;

wire in1,in2,in3;
  wire  [6:0]HEX0;
  wire [6:0]HEX1;
  
  reg in1_de1,in1_de2;
  reg in2_de1,in2_de2;
  



 
                      
     SEG_HEX h1(.iDIG(a),.oHEX_D(HEX0));
  SEG_HEX h2(.iDIG(b),.oHEX_D(HEX1));
                       
  assign in1 = !in1_de1 && in1_de2;
  
  always @(negedge RST_N or posedge CLOCK_50)
  begin
	if(!RST_N)
	begin
		in1_de1<=0;
		in1_de2<=0;
	end
	else begin
		in1_de1<=KEY0;
		in1_de2<=in1_de1;
	
	end
  
  end
  
  assign in2 = !in2_de1 && in2_de2;
  
  always @(negedge RST_N or posedge CLOCK_50)
  begin
	if(!RST_N)
	begin
		in2_de1<=0;
		in2_de2<=0;
	end
	else begin
		in2_de1<=KEY1;
		in2_de2<=in2_de1;
	
	end
  
  
  end
  
  
  always @ (  posedge CLOCK_50) //or negedge in1 or negedge in2 or negedge in3
  
  begin 
  
  
  
    /* begin   
     
	  
	  a<=a+1'b1;
	  
		if(a>4'b1001)
		begin
	  
	   a<=4'b0;
		b<=b+1'b1;
	        if(b>4'b1001  )
	        begin
			  
			  a<=4'b0;
			  b<=4'b0;
			  
			  end
	  
		end
	  
	  end     */
	  
	 
	    
	 	  
      
  
  
	
	
	 
		
   if(in2)
     begin
	  
	   a<=0;
		b<=0;
  
  
     end 
	  
	
   else if(in1)
   begin
		 
	  if(a>=4'b1001 && b>=4'b1001)
	      begin 
			
			a<=0;b<=0;
			
			end 
	   else if(a>=4'b1001 )  
      begin   
      b<=b+1'b1;
	   a<=0;
	  
	   end 
	  
	   else 
	   a<=a+1'b1;
		
  
  end  
	  
	  
  
  else if(in3==0)
     begin
	  
	   a<=0;
		b<=0;
  
  
     end 
  
  
  
  
  
  
  end 


  
  


endmodule   