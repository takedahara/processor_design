module program_counter(pc_e, rst,j_flag,j_addr,  pc_out);
	input 		pc_e;
	input 		rst;
	input j_flag;
	input[15:0]j_addr;
	
	
	output	[15:0] pc_out;
	
	reg	[15:0] pc_out;
	
	always @(posedge pc_e ) begin
		if(j_flag==1)begin
			pc_out<=j_addr+16'b0000000000000001; //j_addr ha PC+ext_d nanode +1 gahituyou
		end
		else begin
		pc_out	<= pc_out+16'b0000000000000001;//pc_inwo16'b1nikaeta
		end
		if(rst==1)begin
			pc_out<=16'b0000000000000000;
		end
	end
	
	
	
endmodule