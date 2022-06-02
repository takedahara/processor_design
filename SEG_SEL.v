module SEG_SEL(in,seg_sel,seg_sel_1,seg_sel_2,seg_sel_3,seg_sel_4,seg_sel_5,seg_sel_6,seg_sel_7);
	input [2:0]in;
	output seg_sel,seg_sel_1,seg_sel_2,seg_sel_3,seg_sel_4,seg_sel_5,seg_sel_6,seg_sel_7;
	
	assign seg_sel=(in==3'b000)? 1'b1:1'b0;
	assign seg_sel_1=(in==3'b001)? 1'b1:1'b0;
	assign seg_sel_2=(in==3'b010)? 1'b1:1'b0;
	assign seg_sel_3=(in==3'b011)? 1'b1:1'b0;
	assign seg_sel_4=(in==3'b100)? 1'b1:1'b0;
	assign seg_sel_5=(in==3'b101)? 1'b1:1'b0;
	assign seg_sel_6=(in==3'b110)? 1'b1:1'b0;
	assign seg_sel_7=(in==3'b111)? 1'b1:1'b0;
endmodule
	