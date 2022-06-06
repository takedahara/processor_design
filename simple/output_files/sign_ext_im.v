module sign_ext_im(d,result);
	input[10:0]d;
	output[15:0]result;
	
	assign result={{10{d[10]}},{d[10:8]},{d[2:0]}};
endmodule
