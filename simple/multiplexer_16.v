module multiplexer_16(mux_s, mux_in_a, mux_in_b, mux_out);
	input 		mux_s;
	input	[15:0] mux_in_a;
	input	[15:0] mux_in_b;
	output	[15:0] mux_out;
	
	assign mux_out = (mux_s == 1'b0) ? mux_in_a : mux_in_b;
	
endmodule