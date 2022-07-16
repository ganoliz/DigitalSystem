`timescale 1ns/10ps
module lab4(clk_50M,reset_n,write,write_control,write_address,write_data,write_complete,i2c_sda_1,i2c_scl);



	input clk_50M,reset_n,write;
	input [7:0]write_control;
	input [7:0] write_data;
	input [15:0] write_address;
	
	output reg write_complete;
	output reg i2c_scl;
	inout i2c_sda_1;
	reg i2c_sda;

	reg write_d1;
	reg write_d2;

	reg scl_d1;
	reg scl_d2;

	reg start;
	reg OE;

	assign write_neg= ~write_d1 & write_d2;
	assign write_pos= write_d1 & ~write_d2;

	reg [6:0] count_scl;
	reg init;
	reg [20:0] count_100us;

	reg [20:0] count_50us;

	wire out= i2c_sda;
	assign i2c_sda_1 =out;


always @ (posedge clk_50M or negedge reset_n)
begin


	if(!reset_n)
	begin


		write_complete<=1'b1;
		i2c_scl<=1'b1;
		i2c_sda<=1'b1;
		write_d1<= #1 1'b0;
		write_d2<= #1 1'b0;
		start<=1'b0;
		count_scl<=7'd0;
		count_100us<=20'd0;
		count_50us<=20'd0;
		init<=1'b0;


	end
	else begin

		write_d1<= #1 write;
		write_d2<= #1 write_d1;


		if(write_pos==1 && write_complete==1'b1)
		begin

			i2c_sda<=1'b0;
			start<=1'b1;
			write_complete<=1'b0;
		end

		if(start==1)
		begin

			i2c_sda<=1'b0;
			init<=1'b1;   //flag for start scl;
			start<=1'b0;
	
		end
		
		if(init==1 && count_scl<7'd75)   // if count_scl<40 bits

		begin

			if(count_100us<20'd5000)
			begin
			
				count_100us<=count_100us+1'd1;
	
			end
			else if(count_100us>=20'd5000)
			begin

				count_100us<=20'd0;
				count_scl<=count_scl+1'd1;

			end
			

		end

		else if(init==1 && count_scl>=7'd75)
		begin
			init<=1'b0;
			count_scl<=7'd0;
			
		end
		
		case(count_scl)
		
		7'd1: begin  i2c_scl<=1'b0; if(count_50us<2500)begin    count_50us<=count_50us+1'd1; end  else if(count_50us>=2500)i2c_sda<=write_control[7];  end
		7'd2: begin  i2c_scl<=1'b1; count_50us<=20'd0; i2c_sda<=write_control[7];  end
		7'd3: begin  i2c_scl<=1'b0; if(count_50us<2500)begin    count_50us<=count_50us+1'd1; end  else if(count_50us>=2500)i2c_sda<=write_control[6];  end
		7'd4: begin  i2c_scl<=1'b1;count_50us<=20'd0; i2c_sda<=write_control[6];  end
		7'd5: begin  i2c_scl<=1'b0; if(count_50us<2500)begin    count_50us<=count_50us+1'd1; end  else if(count_50us>=2500)i2c_sda<=write_control[5];  end
		7'd6: begin  i2c_scl<=1'b1;count_50us<=20'd0; i2c_sda<=write_control[5];  end
		7'd7: begin  i2c_scl<=1'b0; if(count_50us<2500)begin    count_50us<=count_50us+1'd1; end  else if(count_50us>=2500)i2c_sda<=write_control[4];  end
		7'd8: begin  i2c_scl<=1'b1;count_50us<=20'd0; i2c_sda<=write_control[4];  end

		7'd9: begin  i2c_scl<=1'b0; if(count_50us<2500)begin    count_50us<=count_50us+1'd1; end  else if(count_50us>=2500)i2c_sda<=write_control[3];  end
		7'd10: begin  i2c_scl<=1'b1;count_50us<=20'd0; i2c_sda<=write_control[3];  end
		7'd11: begin  i2c_scl<=1'b0;if(count_50us<2500)begin    count_50us<=count_50us+1'd1; end  else if(count_50us>=2500) i2c_sda<=write_control[2];  end
		7'd12: begin  i2c_scl<=1'b1;count_50us<=20'd0; i2c_sda<=write_control[2];  end
		7'd13: begin  i2c_scl<=1'b0;if(count_50us<2500)begin    count_50us<=count_50us+1'd1; end  else if(count_50us>=2500) i2c_sda<=write_control[1];  end
		7'd14: begin  i2c_scl<=1'b1;count_50us<=20'd0; i2c_sda<=write_control[1];  end
		7'd15: begin  i2c_scl<=1'b0; if(count_50us<2500)begin    count_50us<=count_50us+1'd1; end  else if(count_50us>=2500)i2c_sda<=write_control[0];  end
		7'd16: begin  i2c_scl<=1'b1;count_50us<=20'd0; i2c_sda<=write_control[0];  end

		7'd17: begin  i2c_scl<=1'b0;if(count_50us<2500)begin    count_50us<=count_50us+1'd1; end  else if(count_50us>=2500) i2c_sda<=1'bz;  end
		7'd18: begin  i2c_scl<=1'b1;count_50us<=20'd0; i2c_sda<=1'bz;  end
                                                                         //High address
 		7'd19: begin  i2c_scl<=1'b0;if(count_50us<2500)begin    count_50us<=count_50us+1'd1; end  else if(count_50us>=2500) i2c_sda<=1'b0;  end
		7'd20: begin  i2c_scl<=1'b1; count_50us<=20'd0;i2c_sda<=1'b0;  end
		7'd21: begin  i2c_scl<=1'b0; if(count_50us<2500)begin    count_50us<=count_50us+1'd1; end  else if(count_50us>=2500)i2c_sda<=write_address[14];  end
		7'd22: begin  i2c_scl<=1'b1; count_50us<=20'd0;i2c_sda<=write_address[14];  end
		7'd23: begin  i2c_scl<=1'b0; if(count_50us<2500)begin    count_50us<=count_50us+1'd1; end  else if(count_50us>=2500)i2c_sda<=write_address[13];  end
		7'd24: begin  i2c_scl<=1'b1; count_50us<=20'd0;i2c_sda<=write_address[13];  end
		7'd25: begin  i2c_scl<=1'b0; if(count_50us<2500)begin    count_50us<=count_50us+1'd1; end  else if(count_50us>=2500)i2c_sda<=write_address[12];  end
		7'd26: begin  i2c_scl<=1'b1;count_50us<=20'd0; i2c_sda<=write_address[12];  end

		7'd27: begin  i2c_scl<=1'b0; if(count_50us<2500)begin    count_50us<=count_50us+1'd1; end  else if(count_50us>=2500)i2c_sda<=write_address[11];  end
		7'd28: begin  i2c_scl<=1'b1; count_50us<=20'd0;i2c_sda<=write_address[11];  end
		7'd29: begin  i2c_scl<=1'b0; if(count_50us<2500)begin    count_50us<=count_50us+1'd1; end  else if(count_50us>=2500)i2c_sda<=write_address[10];  end
		7'd30: begin  i2c_scl<=1'b1;count_50us<=20'd0; i2c_sda<=write_address[10];  end
		7'd31: begin  i2c_scl<=1'b0;if(count_50us<2500)begin    count_50us<=count_50us+1'd1; end  else if(count_50us>=2500) i2c_sda<=write_address[9];  end
		7'd32: begin  i2c_scl<=1'b1;count_50us<=20'd0; i2c_sda<=write_address[9];  end
		7'd33: begin  i2c_scl<=1'b0; if(count_50us<2500)begin    count_50us<=count_50us+1'd1; end  else if(count_50us>=2500)i2c_sda<=write_address[8];  end
		7'd34: begin  i2c_scl<=1'b1; count_50us<=20'd0; i2c_sda<=write_address[8];  end

		7'd35: begin  i2c_scl<=1'b0;if(count_50us<2500)begin    count_50us<=count_50us+1'd1; end  else if(count_50us>=2500) i2c_sda<=1'bz;  end
		7'd36: begin  i2c_scl<=1'b1;count_50us<=20'd0; i2c_sda<=1'bz;  end

										//Low address

		7'd37: begin  i2c_scl<=1'b0;if(count_50us<2500)begin    count_50us<=count_50us+1'd1; end  else if(count_50us>=2500) i2c_sda<=write_address[7];  end
		7'd38: begin  i2c_scl<=1'b1;count_50us<=20'd0; i2c_sda<=write_address[7];  end
		7'd39: begin  i2c_scl<=1'b0;if(count_50us<2500)begin    count_50us<=count_50us+1'd1; end  else if(count_50us>=2500) i2c_sda<=write_address[6];  end
		7'd40: begin  i2c_scl<=1'b1;count_50us<=20'd0; i2c_sda<=write_address[6];  end
		7'd41: begin  i2c_scl<=1'b0;if(count_50us<2500)begin    count_50us<=count_50us+1'd1; end  else if(count_50us>=2500) i2c_sda<=write_address[5];  end
		7'd42: begin  i2c_scl<=1'b1;count_50us<=20'd0; i2c_sda<=write_address[5];  end
		7'd43: begin  i2c_scl<=1'b0;if(count_50us<2500)begin    count_50us<=count_50us+1'd1; end  else if(count_50us>=2500) i2c_sda<=write_address[4];  end
		7'd44: begin  i2c_scl<=1'b1;count_50us<=20'd0; i2c_sda<=write_address[4];  end

		7'd45: begin  i2c_scl<=1'b0;if(count_50us<2500)begin    count_50us<=count_50us+1'd1; end  else if(count_50us>=2500) i2c_sda<=write_address[3];  end
		7'd46: begin  i2c_scl<=1'b1;count_50us<=20'd0; i2c_sda<=write_address[3];  end
		7'd47: begin  i2c_scl<=1'b0; if(count_50us<2500)begin    count_50us<=count_50us+1'd1; end  else if(count_50us>=2500)i2c_sda<=write_address[2];  end
		7'd48: begin  i2c_scl<=1'b1;count_50us<=20'd0; i2c_sda<=write_address[2];  end
		7'd49: begin  i2c_scl<=1'b0;if(count_50us<2500)begin    count_50us<=count_50us+1'd1; end  else if(count_50us>=2500) i2c_sda<=write_address[1];  end
		7'd50: begin  i2c_scl<=1'b1;count_50us<=20'd0; i2c_sda<=write_address[1];  end
		7'd51: begin  i2c_scl<=1'b0;if(count_50us<2500)begin    count_50us<=count_50us+1'd1; end  else if(count_50us>=2500) i2c_sda<=write_address[0];  end
		7'd52: begin  i2c_scl<=1'b1;count_50us<=20'd0; i2c_sda<=write_address[0];  end


		7'd53: begin  i2c_scl<=1'b0;if(count_50us<2500)begin    count_50us<=count_50us+1'd1; end  else if(count_50us>=2500) i2c_sda<=1'bz;  end
		7'd54: begin  i2c_scl<=1'b1;count_50us<=20'd0; i2c_sda<=1'bz;  end

		7'd55: begin  i2c_scl<=1'b0; if(count_50us<2500)begin    count_50us<=count_50us+1'd1; end  else if(count_50us>=2500)i2c_sda<=write_data[7];  end
		7'd56: begin  i2c_scl<=1'b1;count_50us<=20'd0; i2c_sda<=write_data[7];  end
		7'd57: begin  i2c_scl<=1'b0; if(count_50us<2500)begin    count_50us<=count_50us+1'd1; end  else if(count_50us>=2500)i2c_sda<=write_data[6];  end
		7'd58: begin  i2c_scl<=1'b1;count_50us<=20'd0; i2c_sda<=write_data[6];  end
		7'd59: begin  i2c_scl<=1'b0; if(count_50us<2500)begin    count_50us<=count_50us+1'd1; end  else if(count_50us>=2500)i2c_sda<=write_data[5];  end
		7'd60: begin  i2c_scl<=1'b1;count_50us<=20'd0; i2c_sda<=write_data[5];  end
		7'd61: begin  i2c_scl<=1'b0; if(count_50us<2500)begin    count_50us<=count_50us+1'd1; end  else if(count_50us>=2500)i2c_sda<=write_data[4];  end
		7'd62: begin  i2c_scl<=1'b1;count_50us<=20'd0; i2c_sda<=write_data[4];  end

		7'd63: begin  i2c_scl<=1'b0; if(count_50us<2500)begin    count_50us<=count_50us+1'd1; end  else if(count_50us>=2500)i2c_sda<=write_data[3];  end
		7'd64: begin  i2c_scl<=1'b1;count_50us<=20'd0; i2c_sda<=write_data[3];  end
		7'd65: begin  i2c_scl<=1'b0; if(count_50us<2500)begin    count_50us<=count_50us+1'd1; end  else if(count_50us>=2500)i2c_sda<=write_data[2];  end
		7'd66: begin  i2c_scl<=1'b1;count_50us<=20'd0; i2c_sda<=write_data[2];  end
		7'd67: begin  i2c_scl<=1'b0; if(count_50us<2500)begin    count_50us<=count_50us+1'd1; end  else if(count_50us>=2500)i2c_sda<=write_data[1];  end
		7'd68: begin  i2c_scl<=1'b1;count_50us<=20'd0; i2c_sda<=write_data[1];  end
		7'd69: begin  i2c_scl<=1'b0; if(count_50us<2500)begin    count_50us<=count_50us+1'd1; end  else if(count_50us>=2500)i2c_sda<=write_data[0];  end
		7'd70: begin  i2c_scl<=1'b1;count_50us<=20'd0; i2c_sda<=write_data[0];  end

		7'd71: begin  i2c_scl<=1'b0; if(count_50us<2500)begin    count_50us<=count_50us+1'd1; end  else if(count_50us>=2500)  i2c_sda<=1'bz;  end
		7'd72: begin  i2c_scl<=1'b1;count_50us<=20'd0; i2c_sda<=1'bz;  end
                                                                             //stop
		7'd73:begin  i2c_scl<=1'b0; i2c_sda<=1'b0; end
		7'd74:begin  i2c_scl<=1'b1; i2c_sda<=1'b0; end
		7'd75:begin  i2c_scl<=1'b1; i2c_sda<=1'b1;  write_complete<=1'b1; end


		endcase










	end











end
	











endmodule
