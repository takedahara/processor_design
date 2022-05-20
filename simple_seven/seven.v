module seven(in, signal, out);
	input [15:0] in; // from ar 
	input signal; // if signal==0, output 0
	output [31:0] out; // to 7segLED
	
	wire [7:0] out1, out2, out3, out4;
	
	displaydigit digit1 (
	.bin(in[15:12]),
	.led(out1)
	);

	displaydigit digit2 (
	.bin(in[11:8]),
	.led(out2)
	);

	displaydigit digit3 (
	.bin(in[7:4]),
	.led(out3)
	);
	
	displaydigit digit4 (
	.bin(in[3:0]),
	.led(out4)
	);
		
	assign out = (signal) ? {out1, out2, out3, out4}:
						32'b0000_0000_0000_0000_0000_0000_0000_0000;
endmodule
	