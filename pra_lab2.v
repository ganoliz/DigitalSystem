`timescale 1ns/1ns
module pra_lab2(clk,test_clk,reset_n,HEX0,HEX1,HEX2,HEX3,HEX4,HEX5,HEX6,HEX7);




input clk,test_clk,reset_n;

wire clk,test_clk,clk_1s;

output [6:0] HEX0;output  [6:0]HEX1;output [6:0]HEX2;output [6:0]HEX3; output  [6:0]HEX4;output [6:0]HEX5;output[6:0]HEX6;output[6:0]HEX7;


wire [7:0] HEX0 ;wire[7:0]HEX1 ;wire[7:0]HEX2;wire[7:0]HEX3;wire[7:0]HEX4;wire[7:0]HEX5;wire[7:0]HEX6;wire[7:0]HEX7;

reg [30:0]count=31'd0;

reg [3:0]a=1'b0;reg[3:0]b=1'b0;reg[3:0]c=1'b0;reg[3:0]d=1'b0;reg[3:0]e=1'b0;reg[3:0]f=1'b0;reg[3:0]g=1'b0;reg[3:0]h=1'b0;


reg [3:0]a_fin=1'b0;reg[3:0]b_fin=1'b0;reg[3:0]c_fin=1'b0;reg[3:0]d_fin=1'b0;reg[3:0]e_fin=1'b0;reg[3:0]f_fin=1'b0;reg[3:0]g_fin=1'b0;reg[3:0]h_fin=1'b0;

assign clk_1s=count[25];


reg [3:0]count_sec=4'b0;



reg data_in_d1 ;
reg data_in_d2;


assign pos_edge =  data_in_d1 & ~data_in_d2;
assign neg_edge =  ~data_in_d1 & data_in_d2;





always @(posedge clk or negedge reset_n )
begin

 if(reset_n==0)
 begin
 
 count_sec<=0;
 count<=31'd0;
 a<=0;
 b<=0;
 c<=0;
 d<=0;
 e<=0;
 f<=0;
 g<=0;
 h<=0;
 	a_fin<=0;
	b_fin<=0;
	c_fin<=0;
	d_fin<=0;
	e_fin<=0;
	f_fin<=0;
	g_fin<=0;
	h_fin<=0;
     data_in_d1 <=#1 1'b0;
    data_in_d2 <=#1 1'b0;
 
 end
 
else 
     begin  

    data_in_d1 <=#1 test_clk;
    data_in_d2 <=#1 data_in_d1; 


	

  if(count<31'd50_00_0000 )
	
	begin
	count<=count+1'b1;
	
	
	
	
	
	
 
	
	
	
	
	
	
    if(count_sec<4'b0001)
 
     begin
 
 
 
 
 
 
 if(pos_edge==1)
  begin
   	if(a<4'b1001)
		  a<=a+1'b1;
		
		
  else  if(a>=4'b1001)
	 begin
 
    a<=4'b0;
	if(b<4'b1001) 
	 b<=b+1'b1;
	
	                      
 
 
 
  else if(b>=4'b1001)
	begin
 
   b<=4'b0;
	
	if(c<4'b1001)
	c<=c+1'b1;
	
	                     
 
 
 
  else	if(c>=4'b1001)
	begin
 
	c<=4'b0;
	if(d<4'b1001)
	d<=d+1'b1;
 
 
	
	else if(d>=4'b1001)
	begin
 
	d<=4'b0;
	if(e<4'b1001)
	e<=e+1'b1;
 
 
	
 
 
 
 
	else if(e>=4'b1001)
	begin
 
	e<=4'b0;
	if(f<4'b1001)
	f<=f+1'b1;
 
 
	
 else	if(f>=4'b1001)
	begin
 
	f<=4'b0;
	if(g<4'b1001)
	g<=g+1'b1;
 
 
	
 
 else	if(g>=4'b1001)
	begin
 
	g<=4'b0;
	h<=h+1'b1;
 
 
	
     end  end end  end  end  end  end
 
 end
 

 end

	else if(count_sec>=4'b0001)
  
	begin
	
	count_sec<=4'b0;
	a_fin<=a;
	b_fin<=b;
	c_fin<=c;
	d_fin<=d;
	e_fin<=e;
	f_fin<=f;
	g_fin<=g;
	h_fin<=h;
	a<=0;
	b<=0;
	c<=0;
	d<=0;
	e<=0;
	f<=0;
	g<=0;
	h<=0;

   end

end
	
	
	
	
	else if(count>=31'd50_00_0000) begin
	
	
	count<=31'd0;
	count_sec<=count_sec+1'b1;
	
	
	
	end
  end	
	
end

 SEG_HEX h1(.iDIG(a_fin),.oHEX_D(HEX0));
 SEG_HEX h2(.iDIG(b_fin),.oHEX_D(HEX1));
 SEG_HEX h3(.iDIG(c_fin),.oHEX_D(HEX2));
 SEG_HEX h4(.iDIG(d_fin),.oHEX_D(HEX3));
 SEG_HEX h5(.iDIG(e_fin),.oHEX_D(HEX4));
 SEG_HEX h6(.iDIG(f_fin),.oHEX_D(HEX5));
 SEG_HEX h7(.iDIG(g_fin),.oHEX_D(HEX6));
 SEG_HEX h8(.iDIG(h_fin),.oHEX_D(HEX7));













endmodule 