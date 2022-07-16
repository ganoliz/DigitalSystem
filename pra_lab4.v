module lab_pre4(clk_50,reset_n,IRDA,client_1,client_2,client_3,client_4,key_1,key_2,inverse_1,inverse_2,lcd_EN,
        lcd_RW,lcd_ON,lcd_RS,lcd_DATA);


input clk_50,reset_n  ;

input IRDA;



output reg [3:0] client_1;
output reg [3:0] client_2;
output reg [3:0] client_3;
output reg [3:0] client_4;
output reg [3:0] key_1;
output reg [3:0] inverse_1;
output reg [3:0] key_2;
output reg [3:0] inverse_2;


output reg lcd_EN,lcd_RW,lcd_ON,lcd_RS;


output reg [7:0]lcd_DATA;


reg [2:0] state;

reg[2:0]  state_lcd=3'b0;

reg [20:0] counter_init=21'd0;  // for initial time
reg [3:0]init_set=4'd0;    // initial steps
reg  [3:0]state_counter=4'b0;
reg  [2:0]counter_ST=3'b0;   // count for state_counter 
reg [19:0]delay=20'd0;

reg   [2:0] address=3'b0; // for address index
reg   [19:0] delay_state=20'd0;
reg delay_flag;

reg IRDA_d1;

reg IRDA_d2;

assign IRDA_neg=~IRDA_d1 & IRDA_d2;
assign IRDA_pos=IRDA_d1 & ~IRDA_d2;

reg [19:0] count_leader_1;
reg [19:0] count_leader_2;

reg [19:0] count_logic_1;
reg [19:0] count_logic_2;

reg [1:0] edge_state;  // flag for edge

reg [9:0] data_cnt;

reg [31:0] full_data;

reg test_logic;
reg stop_wait;

parameter Idle_state=3'b0;
parameter Leader_Check_state=3'b001;
parameter Receive_Data_state=3'b010;
parameter Data_Check_state=3'b011;

parameter state_initial=3'b100;
parameter state_send_address=3'b101;
parameter state_send_data=3'b110;


always @(posedge clk_50 or negedge reset_n)

begin


		if(!reset_n)
		begin
		
		
			lcd_RW<=1'b0;
			lcd_ON<=1'b0;
			lcd_RS<=1'b0;
			lcd_EN<=1'b0;
			lcd_DATA<=8'b0;
			counter_ST<=3'b0;
		   state_counter<=4'b0;
			delay_state<=20'd0;
			address<=3'b0;
		   delay<=20'd0;
			counter_init<=21'd0;
			init_set<=4'd0;
			delay_flag<=1'b0;
			
			state<=Idle_state;
			state_lcd<=state_initial;
			
			edge_state<=2'b0;
			
			IRDA_d1<=1'b0;
			IRDA_d2<=1'b0;
			
			count_leader_1<=20'd0;
			count_leader_2<=20'd0;
			count_logic_1<=20'd0;
			count_logic_2<=20'd0;
			
			data_cnt<=10'b0;
			full_data<=32'b0;
			test_logic<=1'b0;
			stop_wait<=1'b0;
			
			
		client_1<=3'b0;
		client_2<=3'b0;
		client_3<=3'b0;
		client_4<=3'b0;
		key_1<=3'b0;
		inverse_1<=3'b0;
		key_2<=3'b0;
		inverse_2<=3'b0;
			
		end
		else begin
		
			IRDA_d1<= #1 IRDA;
			IRDA_d2<=#1 IRDA_d1;
		
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
				
					4'd0: begin   lcd_EN<=1'b0;              end
					4'd1: begin   lcd_EN<=1'b0;              end
					4'd2: begin   lcd_EN<=1'b1;              end
					4'd3: begin   lcd_EN<=1'b1;              end
					4'd4: begin   lcd_EN<=1'b1;              end
					4'd5: begin   lcd_EN<=1'b0;              end
					4'd6: begin   lcd_EN<=1'b0;              end
					4'd7: begin   lcd_EN<=1'b0;              end
				endcase	
					if(state_counter==4'd7)
					begin
					
					if(init_set==2)
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
			
		
		  if(counter_init<21'd1000000)
				begin
			
					counter_init<=counter_init+1'd1;
				
				end
		
	      
			else if(counter_init>=21'd1000000)	
		   begin
				

				if(state_lcd==state_initial)
				begin 
					if(init_set==0)
					begin
							if(state_counter>=4'd0 && state_counter<4'd6)
							begin
									lcd_RS<=0; lcd_RW<=0; 
							end
						
						if(state_counter>=4'd1 && state_counter< 4'd6)
						begin
								lcd_DATA<=8'b00111000;  
						end
						
						if(state_counter>=4'd7)
						begin
						
								if(delay<20'd250)
								begin
								
										delay<=delay+1'd1;
								
								end
					   			
								
								else if(delay>=20'd250) begin
								
									init_set<=init_set+1'b1;
									delay<=20'd0;
								end                    
								
								
								
						end	
				   end
						
						
		
			   
					else if (init_set==1)
					begin
						if(state_counter>=4'd0 && state_counter<4'd6)
						begin
						
								lcd_RS<=1'b0; lcd_RW<=1'b0;
						end
				
						if(state_counter>=4'd1 && state_counter< 4'd6)
						begin
								lcd_DATA<=8'b00001000;  
						end
						
						if(state_counter>=4'd7)
						begin
								if(delay<20'd250)
								begin
								
										delay<=delay+1'd1;
								
								end
								
								
								else if(delay>=20'd250)
								begin
								init_set<=init_set+1'b1;
								delay<=20'd0;
								end                      
								
								
						end
			    	
					end	
				
					else if(init_set==2)
					begin
						if(state_counter>=4'd0 && state_counter<4'd6)
						begin
								lcd_RS<=0;  lcd_RW<=0; 
								
						end		
								
						if(state_counter>=4'd1 && state_counter< 4'd6)
						begin
						
								lcd_DATA<=8'b00000001;   
						
						end
						
						if(state_counter>=4'd7)
						begin
						
								if(delay<20'd80000)
								begin
								
										delay<=delay+1'd1;
								
								end
								
								
								else if(delay>=20'd80000)
								begin
								init_set<=init_set+1'b1;
								delay<=20'd0;
								end
				          
							
							 
                  end  				
 				
					end
			   
					else if (init_set==3)
					begin
						if(state_counter>=4'd0 && state_counter<4'd6)
						begin
						
						
								lcd_RS<=0;   lcd_RW<=0;
						end
						
						if(state_counter>=4'd1 && state_counter< 4'd6)
						begin	
						
								lcd_DATA<=8'b00000110; 
					   end
				
						if(state_counter>=4'd7)
						begin
						
					
								if(delay<20'd250)
								begin
								
										delay<=delay+1'd1;
								
								end
								
								
								else if(delay>=20'd250)
								begin
								state<=state_send_address;
								delay<=20'd0;
								end
						            
										
										
						end
						
					end
			 end	
				
				else  if(state_lcd==state_send_address)
				begin
				
				   case(address) 
					
					
					 3'b000:
					   begin 
								if(state_counter>=4'd1 && state_counter< 4'd6)
								begin  
								
									lcd_DATA<=8'b10000000; 
								
								
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
												state_lcd<=state_send_data;      
										end  
										        
											  
								end       
								
							end
		
		
		
		
		
		/*			 3'b001:begin if(state_counter>=4'd1 && state_counter< 4'd6)begin   DB<=8'b10000001; end   else if(state_counter>=4'd7)begin    address<=address+1'b1;   end        end
					 3'b010:begin if(state_counter>=4'd1 && state_counter< 4'd6)begin   DB<=8'b10000010; end  else if(state_counter>=4'd7)begin    address<=address+1'b1;   end        end  
					 3'b011:begin if(state_counter>=4'd1 && state_counter< 4'd6)begin   DB<=8'b10000011; end  else if(state_counter>=4'd7)begin    address<=address+1'b1;   end        end
					 3'b100:begin if(state_counter>=4'd1 && state_counter< 4'd6)begin   DB<=8'b10000100; end  else if(state_counter>=4'd7)begin    address<=address+1'b1;   end        end
					 3'b101:begin if(state_counter>=4'd1 && state_counter< 4'd6)begin   DB<=8'b10000101; end  else if(state_counter>=4'd7)begin    address<=address+1'b1;   end        end
					 3'b110:begin if(state_counter>=4'd1 && state_counter< 4'd6)begin   DB<=8'b10000110; end  else if(state_counter>=4'd7)begin    address<=address+1'b1;   end        end
					 3'b111:begin if(state_counter>=4'd1 && state_counter< 4'd6)begin   DB<=8'b10000111; end  else if(state_counter>=4'd7)begin    address<=3'b0;  state<=state_send_data;  end        end
				   */
				
				 
				 endcase
				 
					if(state_counter>=4'd0 && state_counter<4'd6)
					begin
						lcd_RS<=0;
						lcd_RW<=0;
					end
				
				   

				
				end

				else  if(state_lcd==state_send_data)
				begin
				
					if(state_counter>=4'd0 && state_counter<4'd6)
					begin
							lcd_RS<=1'b1;
							lcd_RW<=1'b0;
					end
				
					 case(address) 
					
					
					 3'b000:begin if(state_counter>=4'd1 && state_counter< 4'd6)begin lcd_DATA<=8'b00110000;  end   else if(state_counter>=4'd7)begin 		if(delay<20'd250)begin  delay<=delay+1'd1;   end else if(delay>=20'd250)begin    delay<=20'd0;  address<=address+1'b1;        end    end  end
					 3'b001:begin if(state_counter>=4'd1 && state_counter< 4'd6)begin lcd_DATA<=8'b00110000;   end   else if(state_counter>=4'd7)begin  		if(delay<20'd250)begin  delay<=delay+1'd1;   end else if(delay>=20'd250)begin    delay<=20'd0;   address<=address+1'b1;        end   end  end
					 3'b010:begin if(state_counter>=4'd1 && state_counter< 4'd6)begin lcd_DATA<=8'b00111010;       end   else if(state_counter>=4'd7)begin 		if(delay<20'd250)begin  delay<=delay+1'd1;   end else if(delay>=20'd250)begin    delay<=20'd0;   address<=address+1'b1;        end   end  end 
					 3'b011:begin if(state_counter>=4'd1 && state_counter< 4'd6)begin lcd_DATA<=8'b00110000;  end   else if(state_counter>=4'd7)begin  	   if(delay<20'd250)begin  delay<=delay+1'd1;   end else if(delay>=20'd250)begin    delay<=20'd0;   address<=address+1'b1;        end   end  end
					 3'b100:begin if(state_counter>=4'd1 && state_counter< 4'd6)begin lcd_DATA<=8'b00110000;   end   else if(state_counter>=4'd7)begin  		if(delay<20'd250)begin  delay<=delay+1'd1;   end else if(delay>=20'd250)begin    delay<=20'd0;   address<=address+1'b1;        end   end  end
					 3'b101:begin if(state_counter>=4'd1 && state_counter< 4'd6)begin lcd_DATA<=8'b00111010;       end   else if(state_counter>=4'd7)begin  		if(delay<20'd250)begin  delay<=delay+1'd1;   end else if(delay>=20'd250)begin    delay<=20'd0;  address<=address+1'b1;        end    end  end
					 3'b110:begin if(state_counter>=4'd1 && state_counter< 4'd6)begin lcd_DATA<=8'b00110000;  end   else if(state_counter>=4'd7)begin   		if(delay<20'd250)begin  delay<=delay+1'd1;   end else if(delay>=20'd250)begin    delay<=20'd0;   address<=address+1'b1;        end    end   end
					 3'b111:begin if(state_counter>=4'd1 && state_counter< 4'd6)begin lcd_DATA<=8'b00110000;   end   else if(state_counter>=4'd7)begin  		if(delay<20'd250)begin  delay<=delay+1'd1;   end else if(delay>=20'd250)begin    delay<=20'd0;  state_lcd<=state_send_address;    address<=3'b0;      end     end   end
				
				
				    endcase
				
				
				
				
				
				end
				
			end	

				
				
				
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		if(state==Idle_state)
		begin
		
		
			if(IRDA_neg==1)
			begin
			
			
			
				state<=Leader_Check_state;
			
			
			
			end
		end
		
		else if(state==Leader_Check_state)
			begin
			
				
				if(IRDA==0 && edge_state==1'b0)
				begin
				
					count_leader_1<=count_leader_1+1'd1;
				
				end
				
				if(IRDA_pos==1'b1)
				begin
				
				
					edge_state<=2'b1;
				
				
				end
				
				
				
				if(IRDA==1 && count_leader_1 >=400000 && count_leader_1 <500000 && edge_state==2'b1)
				begin
				
				
					count_leader_2<=count_leader_2+1'd1;
					
				   

				
				end
				else if(edge_state==2'b1 && count_leader_1 < 400000 )
				begin
				
				
					count_leader_1<=20'd0;
					state<=Idle_state;
				   

				end
				else if(edge_state==2'b1 && count_leader_1 >= 500000 )
				begin
				
				
					count_leader_1<=20'd0;
					state<=Idle_state;
				   
				end
				
				
				if(IRDA_neg==1 &&  count_leader_2 >=200000 && count_leader_2< 300000 && edge_state==2'b1)
				begin
				
				
					count_leader_2<=20'd0;
					count_leader_1<=20'd0;
					state<=Receive_Data_state;
					edge_state<=2'b0;
				
				
				end
				else if(IRDA_neg==1 && count_leader_2 >=300000 && edge_state==2'b1)
				begin
				
					count_leader_2<=20'd0;
					count_leader_1<=20'd0;
					state<=Idle_state;
					edge_state<=2'b0;
				
				end
				else if(IRDA_neg==1 && count_leader_1<200000 && edge_state==2'b1)
				begin
				
				
					count_leader_2<=20'd0;
					count_leader_1<=20'd0;
					state<=Idle_state;
					edge_state<=2'b0;
				
				end
				
			
			end
		
			else if(state==Receive_Data_state)
			begin
		
					
					
					if(IRDA_pos==1 && data_cnt<6'b100000)
					begin
					
						edge_state<=2'b1;
					
					end
					
					else if(IRDA_neg==1 && edge_state==2'b1)  //edge 3
					begin
					
						edge_state<=2'b0;
						   
						
						if(data_cnt<6'b100000)
						begin
								data_cnt<=data_cnt+1'b1;
								test_logic<=1'b1;   // flag for  logic write to reg
						
						end
						
						else if(data_cnt>=6'b100000)
						begin
								
								
								
								stop_wait<=1'b1;
								


						end
						
					
					end
					
					
					if(stop_wait==1'b1)
					begin
					
					
							if(wait_time<20'd20000)
								begin
								
									wait_time<=wait_time+1'b1;
									
								   if(IRDA_pos==1)
									begin
									
												data_cnt<=0;
												test_logic<=1'b0;
												state<=Data_Check_state;
												wait_time<=20'd0;
												stop_wait<=1'b0;
									
									end
								else if(wait_time>=20'd20000)
								begin
								
												data_cnt<=0;
												test_logic<=1'b0;
												state<=Idle_state;
												wait_time<=20'd0;
												full_data<=32'b0;
												stop_wait<=1'b0;
								
								end
								
								
								
								end
					
					
					
					
					
					end
					
					
					
					
					
					
					if(IRDA==0 && edge_state==2'b0) // time locate 1
					begin
					

						
							count_logic_1<=count_logic_1+1'b1;
							

					end
					
					else if(IRDA==1 && edge_state==2'b1) // count 2 time and confirm 1 time
					
					begin
					
							if(count_logic_1<20000)
							begin
							
								count_logic_1<=20'd0;
								edge_state<=2'b0;
								state<=Idle_state;
								data_cnt<=0;
								full_data<=32'b0;
							
							end
							else if(count_logic_1>20000 && count_logic_1<30000)
							begin
							
								
								count_logic_2<=count_logic_2+1'd1;
								
							
							
							end
							else if(count_logic_1>=30000)
							begin
							
								count_logic_1<=20'd0;
								edge_state<=2'b0;
								state<=Idle_state;
								data_cnt<=0;
								full_data<=32'b0;
							
							end
							
					
					end
					else if(test_logic==1'b1)  // time locate 3
					begin
							
							count_logic_1<=20'd0;
							test_logic<=1'b0;
							
							if(count_logic_2<20000)
							begin
							

								state<=Idle_state;
								count_logic_2<=20'd0;
								data_cnt<=0;
								full_data<=32'b0;
								
							
							
							end
							else if(count_logic_2>=20000 && count_logic_2<40000)
							begin
									
							
									full_data<=full_data+( 0 <<(data_cnt-1) );
									
									count_logic_2<=20'd0;

							
							end
							else if(count_logic_2>=40000 && count_logic_2<90000)
							begin
							
							
									full_data<=full_data+( 1 <<(data_cnt-1) );

									count_logic_2<=20'd0;

							
							
							end
							
							else  //  error >90000
							begin
							

								state<=Idle_state;
								count_logic_2<=20'd0;
								data_cnt<=0;	
								full_data<=32'b0;
							
							
							end
					

					end
		

		
		
			end
		
		
		
		else if(state==Data_Check_state)
		begin
		
		
				client_1<=full_data[3:0];
				client_2<=full_data[7:4];
				client_3<=full_data[11:8];
				client_4<=full_data[15:12];
				key_1<=full_data[19:16];
				key_2<=full_data[23:20];
				inverse_1<=full_data[27:24];
				inverse_2<=full_data[31:28];
		
		
				state<=Idle_state;
		
		
		end
		
		
		
		
		
		
		
		
	end
		
		
		
		
		

	






	
	
	
	
	
	
	
	
	
	
	
	
	end
		


endmodule 