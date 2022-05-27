module program_counter(clock, rst,j_flag,j_addr,phase,  pc_out);
	input 		clock;
	input 		rst;
	input j_flag;
	input[15:0]j_addr;
	input [2:0]phase;
	
	
	output	[15:0] pc_out;
	
	reg	[15:0] pc_out;
	reg [2:0] counter;
	
	always @(posedge clock or negedge rst  ) begin
		if(rst==0)begin
			pc_out<=16'b0000000000000000;
		
		end
		else begin
			if(phase==3'b101)begin
				if(j_flag==1)begin
					pc_out<=j_addr+16'b0000000000000001; //j_addr ha PC+ext_d nanode +1 gahituyou
				end
				else begin
				pc_out	<= pc_out+16'b0000000000000001;//pc_inwo16'b1nikaeta
				end
			end
		end
	end
	
	
	
	
endmodule