module lab3(clk_50M,key0,key1,key2,reset_n,RS,RW,DB,EN,ON);





input clk_50M,key0,key1,key2,reset_n;

output  EN,ON;

output RS,RW;

output [7:0]DB;



wire key0,key1,key2;

wire clk_50M;


reg RS,RW;

reg EN,ON;

reg [7:0]DB;

reg [20:0] counter=21'd0;  // for initial time

reg [3:0]init_set=4'd0;    // initial steps

reg [32:0]count_sec=32'b0;  // count for second

reg delay_flag=1'b0;  // for counter 0111 to 0000 



reg  [3:0]state_counter=4'b0;
reg  [2:0]counter_ST=3'b0;   // count for state_counter 
reg [19:0]delay=20'd0;




parameter state_initial=3'b000;

parameter state_send_address=3'b001;

parameter state_send_data=3'b010;

parameter state_delay=3'b011;

parameter state_send_delay_after=3'b100;

reg   [1:0] state=2'b00; // for state machine
reg   [2:0] address=3'b0; // for address index
reg   [2:0] address_1=3'b0;
reg   [2:0] address_2;
reg   [19:0] delay_state=20'd0;

wire key_0,key_1,key_2;


  debounce D1(.clk(clk_50M),.key(key0),.out(key_0),.reset(reset_n));
  debounce D2(.clk(clk_50M),.key(key1),.out(key_1),.reset(reset_n));
  debounce D3(.clk(clk_50M),.key(key2),.out(key_2),.reset(reset_n));

reg key_0_d1;
reg key_0_d2;
reg key_1_d1;
reg key_1_d2;
reg key_2_d1;
reg key_2_d2;


assign neg_key0=~key_0_d1 & key_0_d2;
assign neg_key1=~key_1_d1 & key_1_d2;
assign neg_key2=~key_2_d1 & key_2_d2; 



reg [3:0] S_1=4'b0;reg [3:0] S_10=4'b0;reg [3:0] M_1=4'b0;reg [3:0] M_10=4'b0;reg [3:0] H_1=4'b0;reg [3:0] H_10=4'b0;



always @ (posedge clk_50M or negedge reset_n)
begin



	if(!reset_n)
   begin
	
		
	counter<=21'd0;	
   init_set<=4'd0;
	address<=3'b0;
	address_1<=3'b0;
	address_2<=3'b0;
	state<=state_initial;
	ON<=1'b1;
	EN<=1'b0;
	
	 key_0_d1<=1'b0;
   key_0_d2<= 1'b0;
   key_1_d1<= 1'b0;
   key_1_d2<=1'b0;
   key_2_d1<=1'b0;
   key_2_d2<=1'b0;
	RW<=1'b1;
	RS<=1'b0;
	
	state_counter<=4'b0;
	counter_ST<=3'b0;
	delay_flag<=1'b0;
	delay<=20'd0;
	delay_state<=20'd0;
	
	H_1<=0;
	H_10<=0;
	S_1<=0;
	S_10<=0;
	M_10<=0;
	M_1<=0;   
	
	
	end
	
	else
	begin
	    ON<=1'b1;
		 key_0_d1<= #1 key_0;
		 key_0_d2<= #1 key_0_d1;
		 key_1_d1<= #1 key_1;
		 key_1_d2<= #1 key_1_d1;
		 key_2_d1<= #1 key_2;
		 key_2_d2<= #1 key_2_d1;
		
		if(neg_key0==1)
		begin
		
				if(S_1<4'd9)
				begin
				
						S_1<=S_1+1'b1;
				
				end
				else if(S_1>=4'd9)
				begin
					S_1<=4'd0;
					
					if(S_10<4'd5)
					begin
					
							S_10<=S_10+1'b1;
					
					end
					else if(S_10>=4'd5)
					begin
					
							S_10<=4'd0;
					
					end
				
				
		
		
		     end
		end	  
			  
	 else	if(neg_key1==1'b1)
		begin
		
			if(M_1<4'd9)
			begin
			
			
					M_1<=M_1+1'b1;
			
			
			end
			else if(M_1>=4'd9)
			begin
					
					M_1<=4'd0;
					
					if(M_10<4'd5)
					begin
					
							M_10<=M_10+1'b1;
					
					
					end
					else if(M_10>=4'd5)
					begin
					
							M_10<=4'd0;
					
					end
			
			
			
			
			end
		
		
		
		end
		
	 else	if(neg_key2==1)
		begin
		
			if(H_1<4'd9)
			begin
			
				if(H_10==4'd2 && H_1>=4'd3)
				begin
				
					H_10<=4'd0; H_1<=4'd0;
				
				end
				
				else begin
				H_1<=H_1+1'b1;
				
				end
			end
		
			
		   else if(H_1>=4'd9)
			begin
			
					H_1<=4'd0;
					
					if(H_10<4'd2)
					begin
					
							H_10<=H_10+1'b1;
					
					
					end
					
					else if(H_10>=4'd2)
					begin
					
							H_10<=4'd0;
					
					
					end
			
			
			
			end
				
	 end	
		
		
		
		
		
		if(counter_ST<3'd7)
		begin
		
		
		counter_ST<=counter_ST+1'b1;
		
		
		end
		else if(counter_ST>=3'd7)   //100ns  //140ns
		begin
		
			if(state_counter<4'd7)   // i fix the number from 8
			begin
			
			state_counter<=state_counter+1'b1;
			
			end
			else if(state_counter>=4'd7)
			begin
			
			
			
			
				if(state_counter>=4'd7 && delay_flag==1'b1)
					begin
			
					state_counter<=4'd0;
					delay_flag<=1'b0;
			
					end
			   else if(state_counter>=4'd7 && delay_flag==1'b0)
				begin
			
						state_counter<=4'd7;
			
				end  
			end
			
			counter_ST<=3'd0;
		end
		
			
		case(state_counter)    
				
				4'd0: begin   EN<=1'b0;        delay_flag<=1'b0;      end
				4'd1: begin   EN<=1'b0;              end
				4'd2: begin   EN<=1'b1;              end
			   4'd3: begin   EN<=1'b1;              end
			   4'd4: begin   EN<=1'b1;              end
				4'd5: begin   EN<=1'b0;              end
				4'd6: begin   EN<=1'b0;              end
				4'd7: begin   EN<=1'b0;              end

			endcase	
			
			
			
			
			
			
		/*		if(state_counter==4'd7)
				begin
				 
			  if(init_set==2 )
				  begin
				  
						if(delay_state<20'd90000)
						begin
					
								delay_state<=delay_state+1'd1;
					
						end
						else if(delay_state>=20'd90000)
						begin
					
								delay_state<=20'd0;
								//state_counter<=4'd0; set in the front
								delay_flag<=1'b1;
					
						end
				  
				  
				  end
				  else if(state==state_delay)
				  begin
				  
						if(delay_state<20'd80000)
						begin
					
								delay_state<=delay_state+1'd1;
					
						end
						else if(delay_state>=20'd80000)
						begin
					
								delay_state<=20'd0;
								//state_counter<=4'd0; set in the front
								delay_flag<=1'b1;
					
						end

				  end
					
					
				  
				  else 
				  begin
						if(delay_state<20'd250)
						begin
					
								delay_state<=delay_state+1'd1;
					
						end
						else if(delay_state>=20'd250)
						begin
					
								delay_state<=20'd0;
							//	state_counter<=4'd0;   set in the front
								delay_flag<=1'b1;
					
						end     
				
					end   

				end
			
		*/
		  
		

		
	    
       if(count_sec<31'd50_00_0000 )
	
		 begin
		      count_sec<=count_sec+1'b1;
	
	
	    end
	    
		 else if(count_sec>=31'd50_00_0000)
	    begin
			count_sec<=31'd0;
		 if(S_1<4'd9)
		 begin
			
			S_1<=S_1+1'b1;
		 end 
		 else if(S_1>=4'd9)
		 
		 begin
		   
			S_1<=4'b0;
			
			if(S_10<4'd5)
			begin
		 
					S_10<=S_10+1'b1;
					
				
		
			end
			else if(S_10>=4'd5)
			begin
					S_10<=4'd0;
					
					if(M_1<4'd9)
					begin
					
						M_1<=M_1+1'b1;
						
					
					
					end
					else if(M_1>=4'd9)
					begin
							M_1<=4'b0;
		
							if(M_10<4'd5)
							begin
							
								M_10<=M_10+1'b1;
								
							
							end
							else if(M_10>=4'd5)
							begin
									M_10<=4'b0;
									if(H_1<4'd9)
									begin
									
										if(H_10==4'd2 && H_1>=4'd3)
										begin
											H_1<=4'd0; H_10<=4'd0;
										end
										else begin
												
												H_1<=H_1+1'b1;
												
										end
									
									
									end
									
									else if(H_1>=4'd9)
									begin
									
									H_1<=4'b0;
									if(H_10<4'd2)
									begin
									
									H_10<=H_10+1'b1;
									
									
									end
								else if(H_10>=4'd2 )
									begin
									
									H_10<=4'd0;
							
									
									end
									
									
									
							end
							
						end
							
	
					end
						
			
			  end
			
		 
		end
	
	end
	


   	if(counter<21'd2000000)
			begin
			
				counter<=counter+1'd1;
				
			end
		
	      
		else if(counter>=21'd2000000)	
		   begin
			
			
			  
			  
			  
			  
			  if(state==state_initial)
			  begin 
					if(init_set==0)
					begin
						if(state_counter>=4'd0 && state_counter<4'd7)
						begin
								RS<=0; RW<=0; 
						end
						
						if(state_counter>=4'd0 && state_counter< 4'd7)
						begin
								DB<=8'b00111000;  
						end
						
						if(state_counter>=4'd7)
						begin
						
								if(delay<20'd250)
								begin
								
										delay<=delay+1'd1;
										delay_flag<=1'b0;
										
								
								end
					   			
								
								else if(delay>=20'd250) begin
								
									init_set<=init_set+1'b1;
									delay<=20'd0;
									delay_flag<=1'b1;
								end                    
								
								
								
						end	
				 end
						
						
		
			   
					else if (init_set==1)
					begin
						if(state_counter>=4'd0 && state_counter<4'd7)
						begin
						
								RS<=1'b0; RW<=1'b0;
						end
				
						if(state_counter>=4'd0 && state_counter< 4'd7)
						begin
								DB<=8'b00001100;  
						end
						
						if(state_counter>=4'd7)
						begin
								if(delay<20'd250)
								begin
								
										delay<=delay+1'd1;
										delay_flag<=1'b0;
								
								end
								
								
								else if(delay>=20'd250)
								begin
								init_set<=init_set+1'b1;
								delay<=20'd0;
								delay_flag<=1'b1;
								end                      
								
								
						end
			    	
					end	
				
					else if(init_set==2)
					begin
						if(state_counter>=4'd0 && state_counter<4'd7)
						begin
								RS<=0;  RW<=0; 
								
						end		
								
						if(state_counter>=4'd0 && state_counter< 4'd7)
						begin
						
								DB<=8'b00000001;   
						
						end
						
						if(state_counter>=4'd7)
						begin
						
								if(delay<20'd90000)
								begin
								
										delay<=delay+1'd1;
										delay_flag<=1'b0;
								
								end
								
								
								else if(delay>=20'd90000)
								begin
								init_set<=init_set+1'b1;
								delay<=20'd0;
								delay_flag<=1'b1;
								end
				          
							
							 
                  end  				
 				
					end
			   
					else if (init_set==3)
					begin
						if(state_counter>=4'd0 && state_counter<4'd7)
						begin
						
						
								RS<=0;   RW<=0;
						end
						
						if(state_counter>=4'd0 && state_counter< 4'd7)
						begin	
						
								DB<=8'b00000110; 
					   end
				
						if(state_counter>=4'd7)
						begin
						
					
								if(delay<20'd250)
								begin
								
										delay<=delay+1'd1;
										delay_flag<=1'b0;
								end
								
								
								else if(delay>=20'd250)
								begin
								state<=state_send_address;
								delay<=20'd0;
								delay_flag<=1'b1;
								end
						            
										
										
						end
						
					end
			 end	
				
				else  if(state==state_send_address)
				begin
				
					case (address_2)
					
					3'b000:begin	if(state_counter>=4'd0 && state_counter< 4'd7)  //6
								begin  
								
									DB<=8'b10000000; 
								
								
								end 
								else if(state_counter>=4'd7)
								begin   
										if(delay<20'd250)
										begin 
									
												delay<=delay+1'd1;   
												delay_flag<=1'b0;
										end
											
										else if(delay>=20'd250)
										begin    
												delay<=20'd0; 
												state<=state_send_data; 
												delay_flag<=1'b1;
												
										end  
										        
											  
								end       
							
							
					
					 
					if(state_counter>=4'd0 && state_counter<4'd7)
					begin
						RS<=0;
						RW<=0;
					end
				end
			endcase

				
		 	end		
					

				 
			
		

				else  if(state==state_send_data)
				begin
				
					if(state_counter>=4'd0 && state_counter<4'd7)
					begin
							
							RW<=1'b0;
							RS<=1'b1;
					end
					
					
				
					 case(address_1) 
					
					
					 3'b000:begin if(state_counter>=4'd0 && state_counter< 4'd7)begin DB<=8'b00110000+H_10;  end   else if(state_counter>=4'd7)begin 		if(delay<20'd250)begin  delay<=delay+1'd1; delay_flag<=1'b0;   end else if(delay>=20'd250)begin  delay_flag<=1'b1;  delay<=20'd0;    address_1<=address_1+1'b1;      end    end  end
					 3'b001:begin if(state_counter>=4'd0 && state_counter< 4'd7)begin DB<=8'b00110000+H_1;   end   else if(state_counter>=4'd7)begin  		if(delay<20'd250)begin  delay<=delay+1'd1; delay_flag<=1'b0;  end else if(delay>=20'd250)begin   delay_flag<=1'b1; delay<=20'd0;      address_1<=address_1+1'b1;     end   end  end
					 3'b010:begin if(state_counter>=4'd0 && state_counter< 4'd7)begin DB<=8'b00111010;       end   else if(state_counter>=4'd7)begin 		if(delay<20'd250)begin  delay<=delay+1'd1; delay_flag<=1'b0;  end else if(delay>=20'd250)begin   delay_flag<=1'b1; delay<=20'd0;      address_1<=address_1+1'b1;    end   end  end 
					 3'b011:begin if(state_counter>=4'd0 && state_counter< 4'd7)begin DB<=8'b00110000+M_10;  end   else if(state_counter>=4'd7)begin  	   if(delay<20'd250)begin  delay<=delay+1'd1; delay_flag<=1'b0;  end else if(delay>=20'd250)begin   delay_flag<=1'b1; delay<=20'd0;      address_1<=address_1+1'b1;    end   end  end
					 3'b100:begin if(state_counter>=4'd0 && state_counter< 4'd7)begin DB<=8'b00110000+M_1;   end   else if(state_counter>=4'd7)begin  		if(delay<20'd250)begin  delay<=delay+1'd1; delay_flag<=1'b0;  end else if(delay>=20'd250)begin   delay_flag<=1'b1; delay<=20'd0;      address_1<=address_1+1'b1;    end   end  end
					 3'b101:begin if(state_counter>=4'd0 && state_counter< 4'd7)begin DB<=8'b00111010;       end   else if(state_counter>=4'd7)begin  		if(delay<20'd250)begin  delay<=delay+1'd1; delay_flag<=1'b0;  end else if(delay>=20'd250)begin   delay_flag<=1'b1; delay<=20'd0;       address_1<=address_1+1'b1; end    end  end
					 3'b110:begin if(state_counter>=4'd0 && state_counter< 4'd7)begin DB<=8'b00110000+S_10;  end   else if(state_counter>=4'd7)begin   		if(delay<20'd250)begin  delay<=delay+1'd1; delay_flag<=1'b0;  end else if(delay>=20'd250)begin   delay_flag<=1'b1; delay<=20'd0;      address_1<=address_1+1'b1;     end    end   end
					 3'b111:begin if(state_counter>=4'd0 && state_counter< 4'd7)begin DB<=8'b00110000+S_1;   end   else if(state_counter>=4'd7)begin  		if(delay<20'd250)begin  delay<=delay+1'd1; delay_flag<=1'b0;  end else if(delay>=20'd250)begin   delay_flag<=1'b1; delay<=20'd0;  state<=state_send_address; address_2<=3'b0;    address_1<=3'b0;      end     end   end
				
				
				    endcase
				
				
				
				
				
				end
			/*	else if(state==state_delay)
				begin
				
					if(state_counter>=4'd0 && state_counter<4'd6)
					begin
							RS<=1'b0;
							RW<=1'b0;
					end
						if(state_counter>=4'd1 && state_counter< 4'd6)
						begin	
						
								DB<=8'b00000011; 
					   end
				
						if(state_counter>=4'd7)
						begin
						
					
								if(delay<20'd80000)
								begin
								
										delay<=delay+1'd1;
								
								end
								
								
								else if(delay>=20'd80000)
								begin
								state<=state_send_address;
								address<=3'b0;
								delay<=20'd0;
								end
						            
										
										
						end	
				
				
				
				
				end
				
				*/
				
				

				
				
				
		   end
						
      end
 
  end

endmodule




							
			/*			 3'b001:
					   begin 
								if(state_counter>=4'd1 && state_counter< 4'd6)  //6
								begin  
								
									DB<=8'b10000001; 
								
								
								end 
								else if(state_counter>=4'd7)
								begin   
										if(delay<20'd250)
										begin 
									
												delay<=delay+1'd1;   
												
										end
											
										else if(delay>=20'd250)
										begin    
												delay<=20'd0; 
												state<=state_send_data;     
										end  
										        
											  
								end       
								
							end
						 3'b010:
					   begin 
								if(state_counter>=4'd1 && state_counter< 4'd6)  //6
								begin  
								
									DB<=8'b10000010; 
								
								
								end 
								else if(state_counter>=4'd7)
								begin   
										if(delay<20'd250)
										begin 
									
												delay<=delay+1'd1;   
												
										end
											
										else if(delay>=20'd250)
										begin    
												delay<=20'd0; 
												state<=state_send_data;     
										end  
										        
											  
								end       
								
							end
						
					 3'b011:
					   begin 
								if(state_counter>=4'd1 && state_counter< 4'd6)  //6
								begin  
								
									DB<=8'b10000011; 
								
								
								end 
								else if(state_counter>=4'd7)
								begin   
										if(delay<20'd250)
										begin 
									
												delay<=delay+1'd1;   
												
										end
											
										else if(delay>=20'd250)
										begin    
												delay<=20'd0; 
											state<=state_send_data;      
										end  
										        
											  
								end       
								
							end
						
					 3'b100:
					   begin 
								if(state_counter>=4'd1 && state_counter< 4'd6)  //6
								begin  
								
									DB<=8'b10000100; 
								
								
								end 
								else if(state_counter>=4'd7)
								begin   
										if(delay<20'd250)
										begin 
									
												delay<=delay+1'd1;   
												
										end
											
										else if(delay>=20'd250)
										begin    
												delay<=20'd0; 
												state<=state_send_data;     
										end  
										        
											  
								end       
								
							end
						
					 3'b101:
					   begin 
								if(state_counter>=4'd1 && state_counter< 4'd6)  //6
								begin  
								
									DB<=8'b10000101; 
								
								
								end 
								else if(state_counter>=4'd7)
								begin   
										if(delay<20'd250)
										begin 
									
												delay<=delay+1'd1;   
												
										end
											
										else if(delay>=20'd250)
										begin    
												delay<=20'd0; 
												state<=state_send_data;      
										end  
										        
											  
								end       
								
							end	
						 3'b110:
					   begin 
								if(state_counter>=4'd1 && state_counter< 4'd6)  //6
								begin  
								
									DB<=8'b10000110; 
								
								
								end 
								else if(state_counter>=4'd7)
								begin   
										if(delay<20'd250)
										begin 
									
												delay<=delay+1'd1;   
												
										end
											
										else if(delay>=20'd250)
										begin    
												delay<=20'd0; 
												state<=state_send_data;     
										end  
										        
											  
								end       
								
							end
							 3'b111:
					   begin 
								if(state_counter>=4'd1 && state_counter< 4'd6)  //6
								begin  
								
									DB<=8'b10000111; 
								
								
								end 
								else if(state_counter>=4'd7)
								begin   
										if(delay<20'd250)
										begin 
									
												delay<=delay+1'd1;   
												
										end
											
										else if(delay>=20'd250)
										begin    
												delay<=20'd0; 
												
												state<=state_send_data;
										end  
										        
											  
								end       
								
							end
		 */
		
		/*			 3'b001:begin if(state_counter>=4'd1 && state_counter< 4'd6)begin   DB<=8'b10000001; end   else if(state_counter>=4'd7)begin    address<=address+1'b1;   end        end
					 3'b010:begin if(state_counter>=4'd1 && state_counter< 4'd6)begin   DB<=8'b10000010; end  else if(state_counter>=4'd7)begin    address<=address+1'b1;   end        end  
					 3'b011:begin if(state_counter>=4'd1 && state_counter< 4'd6)begin   DB<=8'b10000011; end  else if(state_counter>=4'd7)begin    address<=address+1'b1;   end        end
					 3'b100:begin if(state_counter>=4'd1 && state_counter< 4'd6)begin   DB<=8'b10000100; end  else if(state_counter>=4'd7)begin    address<=address+1'b1;   end        end
					 3'b101:begin if(state_counter>=4'd1 && state_counter< 4'd6)begin   DB<=8'b10000101; end  else if(state_counter>=4'd7)begin    address<=address+1'b1;   end        end
					 3'b110:begin if(state_counter>=4'd1 && state_counter< 4'd6)begin   DB<=8'b10000110; end  else if(state_counter>=4'd7)begin    address<=address+1'b1;   end        end
					 3'b111:begin if(state_counter>=4'd1 && state_counter< 4'd6)begin   DB<=8'b10000111; end  else if(state_counter>=4'd7)begin    address<=3'b0;  state<=state_send_data;  end        end
				   */
				