module program_counter(pc_e, rst, pc_in, pc_out, pc_inc_out);
	input 		pc_e;
	input 		rst;
	input	[15:0] pc_in;
	output	[15:0] pc_out;
	output	[15:0] pc_inc_out;
	reg	[15:0] pc_out;
	
	always @(posedge pc_e or negedge rst) begin
		if(rst == 1'b0) begin
			pc_out	<= 16'b0000000000000000;
		end else begin
			pc_out	<= pc_in;
		end
	end
	
	assign pc_inc_out = pc_out + 16'b0000000000000001;
	
endmodule