module lab1(clk_50M,KEY1,KEY0,HEX0,HEX1,RST_N);

input clk_50M;
input RST_N;
input KEY0;
input KEY1;

output [6:0] HEX0;
output [6:0] HEX1;

reg [3:0]a;
reg [3:0]b;

wire in1,in2;

wire [6:0] HEX0;
wire [6:0] HEX1;

reg in1_dl_1,in1_dl_2;
reg in2_dl_1,in2_dl_d2;

SEG_HEX h1(.iDIG(a),.oHEX_D(HEX0));
SEG_HEX h2(.iDIG(b),.oHEX_D(HEX1));

  debounce D1(.clk(clk_50M),.key(KEY0),.out(in1),.reset(RST_N));
  debounce D2(.clk(clk_50M),.key(KEY1),.out(in2),.reset(RST_N));
  



always @(  negedge in1 or negedge  in2 or negedge RST_N  )
begin

		if(!RST_N)
		begin
		
				a<=4'b0;
				b<=4'b0;
		
		
		
		end
		else 
		begin
		
				if(in1==0)
				begin
				
					a<=4'b0;
					b<=4'b0;
				
				
				
				end
				else if(in2==0)
				begin
				
					if(a<4'b1001)
					begin
					
						a<=a+1'b1;
					
					
					
					end
					else if(a>=4'b1001)
					begin
						
						a<=4'b0;
						
						if(b<4'b1001)
						begin
						
						
								b<=b+1'b1;
						
						end
						else if(b>=4'b1001)
						begin
						
							b<=4'b0;
						
						end

					
					end
				
				
				end
				

		end



end




endmodule
