module register_16(reg_e, reg_write_en, reg_in, reg_out);
	input           reg_e;
    input           reg_write_en;
	input	    [15:0] reg_in;
	output	reg [15:0] reg_out;
	
	always @(posedge reg_e) begin
		if(reg_write_en) begin 
            reg_out <= reg_in;
            end
	end
	
endmodule