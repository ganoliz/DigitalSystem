`timescale 1ns/10ps


 module hw3(clk_50M,reset_n,write,write_value,write_complete,read,read_value,read_complete,spi_csn,spi_sck,spi_do,spi_di);



input clk_50M,reset_n,write,read;
input [7:0]write_value;
input [7:0]read_value;
output spi_csn,spi_sck,spi_do,spi_di;
output write_complete,read_complete;

reg [7:0]write_value1=7'b0;
reg read_complete=1'b1;

reg spi_sck,spi_di;
reg write_complete=1'b1;
reg spi_csn=1'b1;
reg [7:0] count_clk=8'd0;
reg write_bus2=1'b0;  // for write address
reg write_bus3=1'b0;
reg spi_do;

parameter  [2:0] state_set=3'b000;
parameter [2:0] state_delay=3'b010;
parameter  [2:0] state_write=3'b001;

reg [2:0] state=state_set;


reg sclk_d1 ;
reg sclk_d2;
reg write_d1;
reg write_d2;
reg set_csn=1'b0; 
reg set_complete=1'b0;

reg [2:0] set_index=3'b0;
reg [4:0] write_counter=5'b0;  // for write data index

assign posedge_sclk = sclk_d1 & ~sclk_d2;
assign negedge_sclk=~sclk_d1 &sclk_d2;
assign write_pos=write_d1 & ~write_d2;
assign write_neg=~write_d1 & write_d2;

always @(posedge clk_50M or negedge reset_n)

begin


	if(!reset_n)
        begin

	spi_sck<=1'b0;	
	sclk_d1<=#1 1'b0;
	sclk_d2<=#1 1'b0;
	spi_csn<=1'b1;	

	 set_index<=3'b0;
	write_d1<=#1 1'b0;
	write_d2<=#1 1'b0;
	
        state<=state_set;
	write_complete<=1'b1;
	write_bus2<=1'b0;
	write_bus3<=1'b0;
	spi_do<=1'b0;
	spi_di<=1'b0;
	read_complete<=1'b1;

  	end
 	
	else 
	begin
		
		write_d1<=#1 write;
		write_d2<=#1 write_d1;
		write_value1<=write_value;
		if(write_pos==1)
		begin
			 
			write_complete<=1'b0;

			if(state==state_set && write_counter==5'b0)
			begin
				 spi_do<=write_value1[7] ;  write_counter<=write_counter+1'b1;	
			end
			else if(state==state_write )
			begin

				if(write_counter==5'b0)
				 begin spi_do<=write_value1[7] ;  write_counter<=write_counter+1'b1;	end	
				else if(write_counter==5'b01000)
				begin spi_do<=write_value1[7] ;  write_counter<=write_counter+1'b1;	end	
				else if(write_counter==5'b10000)
				begin spi_do<=write_value1[7] ;  write_counter<=write_counter+1'b1;	end
			end
			
		end
		if(write_neg==1)
		begin
			spi_csn<=0;
		end


                if(spi_csn==0 && write_complete==0 && set_csn==0)  //write_complete to 1'b1
		begin	
			if(set_complete==1'b1)
			begin
				if(count_clk<8'd50)
				begin             count_clk<=count_clk+1'b1; spi_sck<=	1'b0;     end
		
		       		else if(count_clk>=8'd50 )
				begin     spi_sck<=1'b0; write_complete<=1'b1; set_complete<=1'b0;     count_clk<=8'd0;   end
				
				sclk_d1<= #1 spi_sck;  sclk_d2 <= #1 sclk_d1;

			end
	
			else begin
				if(count_clk<8'd50)
				begin             count_clk<=count_clk+1'b1; spi_sck<=spi_sck;     end
		
		       		else if(count_clk>=8'd50 )
				begin     spi_sck<=~spi_sck;     count_clk<=8'd0;   end
				
				sclk_d1<= #1 spi_sck;  sclk_d2 <= #1 sclk_d1;
			end
		end
		
		else if(spi_csn==0 && set_csn==1 && write_complete==0)
		begin

			if(count_clk<8'd50)
			begin             count_clk<=count_clk+1'b1; spi_sck<=1'b0;  sclk_d1<= #1 spi_sck;  sclk_d2 <= #1 sclk_d1;    end
			else if(count_clk>=8'd50 )			
			begin		spi_csn<=1;  count_clk<=8'd0;    write_complete<=1'b1; spi_sck<=1'b0; set_csn<=1'b0; spi_sck<=1'b0;    sclk_d1<= #1 spi_sck;  sclk_d2 <= #1 sclk_d1;            end



			

		end

		else       //if(spi_csn==1 || )
		begin

			spi_sck<=1'b0;
			sclk_d1<= #1 spi_sck;  sclk_d2 <= #1 sclk_d1;
		end



		

	        if(negedge_sclk==1 && spi_csn==0 && write_complete==0)
		begin
			if(state==state_set) 
               		 begin
 		
				case(write_counter)  //WREN
					
					
					5'b00001: begin spi_do<=write_value1[6] ;  write_counter<=write_counter+1'b1;	end	
					5'b00010: begin spi_do<=write_value1[5]  ; write_counter<=write_counter+1'b1;	end	
					5'b00011: begin spi_do<=write_value1[4]  ; write_counter<=write_counter+1'b1;	end	
					5'b00100: begin spi_do<=write_value1[3]  ; write_counter<=write_counter+1'b1;	end	// A
					5'b00101: begin spi_do<=write_value1[2]  ; write_counter<=write_counter+1'b1;	end	
					5'b00110: begin spi_do<=write_value1[1]  ; write_counter<=write_counter+1'b1;	end	
					5'b00111: begin spi_do<=write_value1[0]  ; write_counter<=write_counter+1'b1;     end
					5'b01000:begin write_counter<=5'b0;	state<=state_write  ;set_csn<=1'b1;  end
					//5'b01000: begin  write_counter<=5'b0;	state<=state_write  ;write_complete<=1'b1;spi_csn<=1'b1;end
				endcase

				
				/*set_index<=set_index+1'b1;
				end
				
				else if(set_index==3'b010)
				begin

					case(write_counter)   //WRITE
					
						3'b000: begin spi_do<=write_value[7]   write_counter<=write_counter+1'b1;	end		
					 	3'b001: begin spi_do<=write_value[6]   write_counter<=write_counter+1'b1;	end	
						3'b010: begin spi_do<=write_value[5]   write_counter<=write_counter+1'b1;	end	
						3'b011: begin spi_do<=write_value[4]   write_counter<=write_counter+1'b1;	end	
						3'b100: begin spi_do<=write_value[3]   write_counter<=write_counter+1'b1;	end	// A
						3'b101: begin spi_do<=write_value[2]   write_counter<=write_counter+1'b1;	end	
						3'b110: begin spi_do<=write_value[1]   write_counter<=write_counter+1'b1;	end	
						3'b111: begin spi_do<=write_value[0]   write_counter<=3'b0;	end

					endcase					
				
					set_index<=3'b0;

				end
                                                  */

			end



			else if(state==state_write)
			begin

				if(write_complete==1'b0 && write_bus2==1'b0 && write_bus3==1'b0)			
				begin
					case(write_counter)   //WRITE
						
								
						 	5'b00001: begin spi_do<=write_value1[6] ;  write_counter<=write_counter+1'b1;	end	
							5'b00010: begin spi_do<=write_value1[5] ;  write_counter<=write_counter+1'b1;	end	
							5'b00011: begin spi_do<=write_value1[4] ;  write_counter<=write_counter+1'b1;	end	
							5'b00100: begin spi_do<=write_value1[3] ;  write_counter<=write_counter+1'b1;	end	// A
							5'b00101: begin spi_do<=write_value1[2] ;  write_counter<=write_counter+1'b1;	end	
							5'b00110: begin spi_do<=write_value1[1] ;  write_counter<=write_counter+1'b1;	end	
							5'b00111: begin spi_do<=write_value1[0] ;  write_counter<=5'b10000;  	end
							5'b10000:begin write_counter<=5'b01000;   write_bus2<=1'b1; set_complete<=1'b1; end
							//5'b10000: begin write_counter<=5'b01000;  write_complete<=1'b1; write_bus2<=1'b1;  end
						endcase		

 				end
							
				 else if(write_complete==1'b0 && write_bus2==1'b1)
				begin

					case(write_counter)   //WRITE
					
							
					 	5'b01001: begin spi_do<=write_value1[6] ;  write_counter<=write_counter+1'b1;	end	
						5'b01010: begin spi_do<=write_value1[5] ;  write_counter<=write_counter+1'b1;	end	
						5'b01011: begin spi_do<=write_value1[4] ;  write_counter<=write_counter+1'b1;	end	
						5'b01100: begin spi_do<=write_value1[3] ;  write_counter<=write_counter+1'b1;	end	// A
						5'b01101: begin spi_do<=write_value1[2] ;  write_counter<=write_counter+1'b1;	end	
						5'b01110: begin spi_do<=write_value1[1] ;  write_counter<=write_counter+1'b1;	end	
						5'b01111: begin spi_do<=write_value1[0] ;  write_counter<=5'b00000;   	 end
					5'b00000: begin write_counter<=5'b10000;  write_complete<=1'b1; write_bus3<=1'b1;write_bus2<=1'b0; end // for last step have complete sclk clock
					endcase					
				
				
				end
				
				else if(write_complete==1'b0 && write_bus3==1'b1)
				begin

					case(write_counter)   //WRITE
					
								
					 	5'b10001: begin spi_do<=write_value1[6] ;  write_counter<=write_counter+1'b1;	end	
						5'b10010: begin spi_do<=write_value1[5] ;  write_counter<=write_counter+1'b1;	end	
						5'b10011: begin spi_do<=write_value1[4] ;  write_counter<=write_counter+1'b1;	end	
						5'b10100: begin spi_do<=write_value1[3] ;  write_counter<=write_counter+1'b1;	end	// A
						5'b10101: begin spi_do<=write_value1[2] ;  write_counter<=write_counter+1'b1;	end	
						5'b10110: begin spi_do<=write_value1[1];   write_counter<=write_counter+1'b1;	end	
						5'b10111: begin spi_do<=write_value1[0] ;  write_counter<=5'b00000;   end
						5'b00000: begin write_counter<=5'b00000;    write_complete<=1'b1; write_bus3<=1'b0;spi_csn<=1'b1;	  state<=state_set;end 
					endcase					
				
				
				end
			end
 		end
		/*    else if(negedge_sclk==1 && spi_csn==0 && write_complete==0)
			  begin

					if(state==state_set && write_counter==5'b01000)
					begin
					 	write_counter<=5'b0;	state<=state_write  ;set_csn<=1'b1;    //write_complete<=1'b1;
					end	

					else if(state==state_write )
					begin
							if(write_complete==1'b0 && write_bus2==1'b0 && write_bus3==1'b0 && write_counter==5'b10000)
							begin
								write_counter<=5'b01000;   write_bus2<=1'b1; set_complete<=1'b1;
							end
							else if(write_complete==1'b0 && write_bus2==1'b1 && write_counter==5'b00000)
							begin
								write_counter<=5'b10000;   write_bus3<=1'b1;write_bus2<=1'b0; set_complete<=1'b1;
							end


							else if(write_complete==1'b0 && write_bus3==1'b1 && write_counter==5'b00000)
							begin

								write_counter<=5'b00000;    write_bus3<=1'b0;set_csn<=1'b1;  state<=state_set;
	
							end

					end
			  end			
    					*/
		
           
	end









end









endmodule 