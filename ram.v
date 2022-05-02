module ram(clk_2, mem_e, mem_w, mem_address, mem_in, mem_out);
	input		clk_2;
	input 		mem_e;
	input 		mem_w;
	input 	[15:0]	mem_address;
	input	[15:0]	mem_in;
	output	[15:0]	mem_out;
	reg	[15:0]	reg_address;
	reg	[15:0]	reg_in;
	
	
	always @(posedge mem_e or posedge mem_w) begin
		reg_address <= mem_address;
		reg_in <= mem_in;
	end
	
	ram01 ram01_0(.address(reg_address[12:0]), .clock(clk_2), .data(reg_in), 
	.wren(mem_w), .q(mem_out));
	
endmodule