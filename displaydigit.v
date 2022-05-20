module displaydigit(bin, led);
	input [3:0] bin;
	output [7:0] led; // One hexidecimal digit on the 7segLED

	function [7:0] decode;
	input [3:0] fourbit; // 4-bit binary number
	begin
		case (fourbit)
			0: decode = 8'b11111100;
			1: decode = 8'b01100000;
			2: decode = 8'b11011010;
			3: decode = 8'b11110010;
			4: decode = 8'b01100110;
			5: decode = 8'b10110110;
			6: decode = 8'b10111110;
			7: decode = 8'b11100000;
			8: decode = 8'b11111110;
			9: decode = 8'b11110010;
			10: decode = 8'b11101110;
			11: decode = 8'b00111110;
			12: decode = 8'b00011010;
			13: decode = 8'b01111010;
			14: decode = 8'b10011110;
			15: decode = 8'b10001110;
		endcase
	end
	endfunction
	
	assign led = decode(bin);
endmodule