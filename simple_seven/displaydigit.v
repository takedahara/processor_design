module displaydigit(bin, led);
	input [3:0] bin;
	output [7:0] led; // One hexidecimal digit on the 7segLED

	function [7:0] decode;
	input [3:0] fourbit; // 4-bit binary number
	begin
		case (fourbit)
			0: decode = 8'b01111110;
			1: decode = 8'b00001100;
			2: decode = 8'b10110110;
			3: decode = 8'b10011110;
			4: decode = 8'b11001100;
			5: decode = 8'b11011010;
			6: decode = 8'b11111010;
			7: decode = 8'b00001110;
			8: decode = 8'b11111110;
			9: decode = 8'b11011110;
			10: decode = 8'b11101110;
			11: decode = 8'b11111000;
			12: decode = 8'b10110000;
			13: decode = 8'b10111100;
			14: decode = 8'b11110010;
			15: decode = 8'b11100010;
		endcase
	end
	endfunction
	
	assign led = decode(bin);
endmodule