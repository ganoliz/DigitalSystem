module debounce(key,clk,out,reset);


input key,clk,reset;



reg pre_key;

output out;



reg [22:0]div_count=23'b0;

reg out;


assign ck_1kHz=div_count[16];
reg ck_1k_d1;
reg ck_1k_d2;


assign ck_1k_pos=ck_1k_d1 & ~ck_1k_d2;


always @(posedge clk or negedge reset)

begin
	
	if(!reset)
	begin
	
		pre_key<=1'b1;
	
	end
	
   else begin	
	div_count<=div_count+1;
	ck_1k_d1<= #1 ck_1kHz;
	ck_1k_d2<= #1 ck_1k_d1;
	
	
	if(ck_1k_pos==1)
	begin
		
			if(pre_key==key)
					begin  out<=key; end
					
			else
					begin  out<=out; end
					
			pre_key<=key;			
	
	
	
	
	end

  end

end




 endmodule 