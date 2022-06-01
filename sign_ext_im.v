module sign_ext_im(d,result);
	input[7:0]d;
	output[15:0]result;
	
	assign result={{13{d[2]}},{d[2:0]}};
endmodule
