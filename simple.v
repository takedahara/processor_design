module simple(clk,rst);
	input clk;
	input rst;
	wire alu_e,ar_e,br_e,dr_e,mr_e,ir_e,
	pc_e,mem_e,m1_s,m2_s,m3_s,m4_s,reg_write,reg_read;
	wire [3:0] ALU_Cnt; //alu opcode
	wire [15:0] ar; //AR content
	wire[15:0] br; //BR content
	wire[15:0] dr; //DR content
	wire[15:0] MDR; //MDR content
	wire[15:0] ir; //ir content
	wire[15:0] pc; //
	wire[15:0] pc_inc; //pc+1
	wire[15:0] m1;
	wire[15:0] m2;
	wire[15:0] m3;
	wire[15:0] m4;
	wire[15:0] m5;
	wire[15:0] mem_out1; //meireifech
	wire[15:0] mem_out2; //roadmeirei P4
	wire S,Z,C,V;
	wire [15:0] address;
	wire [15:0] alu_out;
	
	register_16 IR(.reg_e(ir_e), .rst(rst), .reg_in(mem_out1)
	, .reg_out(ir));
	
	register_16 AR(.reg_e(ar_e), .rst(rst), .reg_in(m2)
	, .reg_out(ar));
	
	register_16 BR(.reg_e(br_e), .rst(rst), .reg_in(m3)
	, .reg_out(br));
	
	register_16 DR(.reg_e(dr_e), .rst(rst), .reg_in(alu_out)
	, .reg_out(dr));
	
	register_general(.clk(reg_read),.rst(rst),.reg_write_en(reg_write)
	,.reg_write_dest(m5),.reg_write_data(m4),
	
	alu alu_0(.alu_e(alu_e), .rst(rst), .opcode(ALU_Cnt),.d(ir[3:0]
	,. alu_in_a(ar), .alu_in_b(br), .alu_out(alu_out), .S(S),.Z(Z)
	,.C(C),.V(V));
	
	