`timescale 1ns/1ns
module lab2(clk_50M,
    reset_n,
    write,
    write_value,
    uart_txd);
	 
	 
	 input clk_50M,reset_n,write;
	 
	 wire clk_50M,reset_n,write;
	 
         reg write_d1=1'b0;
         reg write_d2=1'b0;
         reg set=1'b1;
  
        
	assign pos_write=write_d1 & ~write_d2;
         
       assign neg_write= ~ write_d1 & write_d2;
      
      
             
	 input [7:0]write_value;
         
     
	 output  uart_txd;
        
	 
	 reg uart_txd;
	 
	
	 
	 reg uart_clock=1'b0;
	 
         reg uart_clock_d1;
         reg uart_clock_d2;
         assign pos_uart= uart_clock_d1 & ~uart_clock_d2;
         
	 reg [8:0]i=9'd0;
	 
	
	 
	 reg [3:0]counter=4'd0;
	 
 
	 
 
	 
	 
	 always@(  posedge clk_50M  or negedge reset_n )
	 
	 begin 
	 
	 if(!reset_n)
         begin

         write_d1<=#2 1'b0;
         write_d2<=#2 1'b0;
         uart_clock_d1<=#2 1'b0;
         uart_clock_d2<=#2 1'b0;
         i=9'd0;
  
         end
	 
	/* 
	 
	   
	   if(write==0)
		begin
		
		load<=1;
		
		end
	   else 
		
		begin
		
		load<=0;
		
		end
	 
	 */
	
	 
	 
     
           

	 
	else if(reset_n==1 )
	 begin
            write_d1<= #2 write;
	    write_d2<= #2 write_d1; 
             
            
          
             if(neg_write==1)
           begin
           
           set<=1'b1;
          end

            
	if(set==1)
        begin 
        
               // if(i<9'd217)begin   //217
	 i<=i+1'b1;
	 // end

	 if(i>9'd217)   begin              //9'b110110010
	 
	  i<=9'd0;    
	 uart_clock <= ~ uart_clock;   //~
	                   // in front of uart_clock <=!uart_clock;
         uart_clock_d1<= #2 uart_clock;
         uart_clock_d2<= #2 uart_clock_d1;
         
	                                           //    end
                                                          
        if(pos_uart==1 && set==1)
             begin

  
          case(counter) 
	 
	  4'd0 : begin   uart_txd<= 1'b0;             end
	  4'd1 : begin   uart_txd<= write_value[0] ;   end
	  4'd2 : begin   uart_txd<= write_value [1];   end
	  4'd3 : begin   uart_txd<= write_value[2];  end
	  4'd4 : begin   uart_txd<= write_value[3] ;   end
	  4'd5 : begin   uart_txd<= write_value[4] ;  end 
	  4'd6 : begin   uart_txd<= write_value[5] ;   end
	  4'd7 : begin   uart_txd<= write_value[6] ;   end
	  4'd8 : begin   uart_txd<= write_value[7] ;   end
	  
	  4'd9 : begin   uart_txd<= 1'b0;    end
	  4'd10: begin   uart_txd<= 1'b1  ;    end
	 default :  uart_txd<=1'bx;
	 
	 endcase
	 
	    counter<=counter+1'b1;
		 
		 
	
		 
	 if(counter>4'd9)
	 	begin
	    
	    counter<=4'd0;
            set<=1'b0;
	 	end


            end 
         end

      end
   end
end 
	 
	 
	// assign a=(i==434);
	 
	
 
endmodule 
	 