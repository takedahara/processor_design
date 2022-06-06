

module simple(clk,rst,exec,in,out,out2,out3,out4,seg_out,seg_out_2,seg_sel,seg_sel_1,
seg_sel_2,seg_sel_3,seg_sel_4,seg_sel_5,seg_sel_6,seg_sel_7, phase);
	input clk;
	input rst;
	input exec;

	input[15:0]in;
	output[15:0]out;
	output[15:0]out2;
	output[15:0]out3;
	output[31:0]out4;
	output[31:0]seg_out;
	output[31:0]seg_out_2;
	output seg_sel;
	output seg_sel_1;
	output seg_sel_2;
	output seg_sel_3;
	output seg_sel_4;
	output seg_sel_5;
	output seg_sel_6;
	output seg_sel_7;
	
	
	wire aluc_e, ar_e,br_e,dr_e,mdr_e,ir_e,S,Z,C,V,jump,
	mem_e,mem_w,m2_s,m3_s,m4_s,m5_s,m6_s,m7_s,m8_s,m9_s,out_s,hlt,reg_write,reg_read;
	wire [3:0] ALU_Cnt; //alu opcode
	wire[5:0] instruction_six;
	wire [15:0] ar; //AR content
	wire[15:0] br; //BR content
	wire[15:0] dr; //DR content
	wire[15:0] mdr; //MDR content
	wire[15:0] ir; //ir content
	wire[15:0] pc; //
	wire[15:0] pc_inc; //pc+1
	wire[15:0] m2;
	wire[15:0] m3;
	wire[15:0] m4;
	wire[15:0] m5;
	
	wire[15:0] m7;
	wire[15:0] m8;
	wire[15:0] m9;
	wire[15:0] m10;
	wire[15:0] mem_out1; //meireifech
	wire[15:0] mem_out2; //roadmeirei P4
	wire[15:0] exd;
	wire[15:0] exd_im;
	wire[15:0] re0;
	wire[15:0] re1;
	wire[15:0] pc_out;
	wire [15:0] address;
	wire [15:0] alu_out;
	wire[3:0] Flag;
	wire seg_sel;
	wire seg_sel_1;
	wire seg_sel_2;
	wire seg_sel_3;
	wire seg_sel_4;
	wire seg_sel_5;
	wire seg_sel_6;
	wire seg_sel_7;
	wire rst_n;
	wire exec_n;
	wire szcv_s;
	
	assign rst_n=~rst;
	assign exec_n=~exec;
	assign instruction_six={{ir[15:14]},{ir[7:4]}};
	
	

	reg pc_e;
	wire[15:0]out;
	

	output reg[2:0]phase=3'b000;
	reg executing = 0; // 実行中・停止中を表す
	reg stop_flag = 0; // if stop_flag == 1, then stop after this instruction


	// 3'b000: 初期状態, 3'b001: Phase１, 3'b010: Phase 2, ...
	always@(posedge clk or negedge rst)begin
		if(rst==0)begin
			phase <= 3'b000;
			executing <=0;  //  1 ni sitemita
			stop_flag<=0;
		end else begin
			
			if (phase == 3'b000||phase==3'b001||phase==3'b010||phase==3'b011||phase==3'b100) begin // if Phase 0
				
				if ( (executing==0 && exec==0) || (executing==1 && exec==1) ) begin
					 // tamesinikuwaeta
					phase <= phase + 3'b001;
					executing <= 1;
					stop_flag<=1'b0; // kokoni kuwaeta
				end else begin
					
					phase <= 3'b000; //stay in 初期状態
					executing<=0;
					
				end
				
			end

			
			else if(phase == 3'b101)begin // if Phase 5
				if(stop_flag==1 ||(executing==1 && exec==0)) begin  // ||executing&exec  wo kuwaeta
					phase <= 3'b000;
					executing <= 0;
				end else begin
				phase <= 3'b001;
				
			
				end
			end
			else begin
				phase <= phase + 3'b001;
			end
			
			if(hlt==1'b1)begin
				stop_flag<=1;
			end
			//stop_flag<=hlt;
			
			
			
			 //kokoniarunoha exec tekini mazui
			
			
		end
	end	
	control controls(.phase(phase),.S(Flag[3]),.Z(Flag[2]),.C(Flag[1]),
	.V(Flag[0]),.instruction(ir),.aluc_e(aluc_e),.ar_e(ar_e)
	,.br_e(br_e),.dr_e(dr_e),.mdr_e(mdr_e),.ir_e(ir_e),.genr_w(genr_w)
	,.mem_e(mem_e)
	,.mem_w(mem_w),.jump(jump) ,.m2_s(m2_s),.m3_s(m3_s),.m4_s(m4_s)
	,.m5_s(m5_s),.m7_s(m7_s),.m8_s(m8_s),.m9_s(m9_s),.out_s(out_s),.hlt(hlt),.szcv_s(szcv_s),.
	alu_instruction(alu_instruction));
	//MEI wo ir nikaeta
	
	seven sev(.in(re0),.signal(out_s),.out(seg_out));  //out_s wo 1'b1   ar wo re0
	 //re0 wo kaeta  mem_out1 wo pc_out
	 
	seven sev2(.in(m10),.signal(out_s),.out(seg_out_2));
	
	SEG_SEL seg_SEL(.in(ir[3:1]),.seg_sel(seg_sel),.seg_sel_1(seg_sel_1),.seg_sel_2(seg_sel_2)
	,.seg_sel_3(seg_sel_3),.seg_sel_4(seg_sel_4),.seg_sel_5(seg_sel_5),.seg_sel_6(seg_sel_6)
	,.seg_sel_7(seg_sel_7));
	
	szcv_register szcv_regi(.reg_e(clk),.reg_write_en(szcv_s),.reg_in({S,Z,C,V}),.reg_out(Flag));
	
	
	register_16 IR(.reg_e(clk), .reg_write_en(ir_e), .reg_in(mem_out1) //MEI wo mem_out1
	, .reg_out(ir)); //ir_e wo 1'b1
	
	register_16 AR(.reg_e(clk), .reg_write_en(ar_e), .reg_in(m9)
	, .reg_out(ar));
	
	register_16 BR(.reg_e(clk), .reg_write_en(br_e), .reg_in(m3)
	, .reg_out(br));
	
	register_16 DR(.reg_e(clk), .reg_write_en(dr_e), .reg_in(alu_out)
	, .reg_out(dr));
	
	register_16 MDR(.reg_e(clk),.reg_write_en(mdr_e),.reg_in(m7)
	,.reg_out(mdr));
	
	register_general registerfile(.clk(clk),.rst(rst),
	.reg_write_en(genr_w)   //reg_e wo genr_w nisita
	,.reg_write_dest(m5),.reg_write_data(m8),.reg_read_addr_1(ir[13:11])
	,.reg_read_data_1(re0),.reg_read_addr_2(ir[10:8]),.reg_read_data_2  //MEI wo ir nisita
	(re1)); 
	
	alu_control_unit aluconu(.alu_control_unit_e(clk)
	,.instruction_six(instruction_six),.ALU_Cnt(ALU_Cnt));
	
	alu alu_0( .opcode(ALU_Cnt),.d(ir[3:0])
	,. alu_in_a(ar), .alu_in_b(br), .alu_out(alu_out), .S(S),.Z(Z)
	,.C(C),.V(V));   //ar wo 3 br wo1  ALU_Cnt wo ir[7:4]
	
	ram01 inst_memory(.data(16'b0),.wren(1'b0),.address(pc_out)  
	,.clock(clk),.q(mem_out1));  
	
	//ram01 inst_memory(.data(16'b0),.wren(1'b0),.address(pc_out),.clock(clk),.q(mem_out1));  
	
	ram02 data_memory(.data(re0),.wren(mem_w),.
	address(alu_out),.clock(clk),.q(mem_out2));
	
	
	
	
	program_counter pc_0(.clock(clk),.rst(rst),.j_flag(jump)
	,.j_addr(dr),.phase(phase),.pc_out(pc_out));   
	
	sign_extension siex(.d(ir[7:0]),.result(exd)); //ir[7:0] wo 8'b00001111
	
	sign_ext_im sign_ext_IM(.d({{ir[13:11]},{ir[7:0]}}),.result(exd_im));
	
	
	multiplexer_16 m2_0(.mux_s(m2_s),.mux_in_a(re0),.mux_in_b(exd)
	,.mux_out(m2));
	
	multiplexer_16 m3_0(.mux_s(m3_s),.mux_in_a(re1),.mux_in_b(pc_out)
	,.mux_out(m3));
	
	multiplexer_16 m4_0(.mux_s(m4_s),.mux_in_a(dr),.mux_in_b(mdr)
	,.mux_out(m4));
	
	multiplexer_16 m5_0(.mux_s(m5_s),.mux_in_a(ir[13:11]),.mux_in_b(ir[10:8]) //MEI wo ir nisita
	,.mux_out(m5));
	
	
	
	multiplexer_16 m7_0(.mux_s(m7_s),.mux_in_a(mem_out2),.mux_in_b(in)
	,.mux_out(m7));
	
	multiplexer_16 m8_0(.mux_s(m8_s),.mux_in_a(m4),.mux_in_b(exd)
	,.mux_out(m8));  //m8_s ga 1 ni nattenai
	
	multiplexer_16 m9_0(.mux_s(m9_s),.mux_in_a(m2),.mux_in_b(exd_im),.mux_out(m9));
	
	multiplexer_16 m10_0(.mux_s(ir[0]),.mux_in_a(16'b0000000000000000),.mux_in_b(re1),.mux_out(m10));

	assign out=mem_out1;
	assign out2=pc_out; //br wo re1
	assign out3=Flag[2];
	assign out4=jump;
	
	endmodule





