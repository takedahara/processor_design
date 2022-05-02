module control(clk,rst,S,Z,C,V,instruction,alu_e,ar_e,br_e,dr_e,mdr_e,ir_e,pc_e,mem_e,m1_s,m2_s,m3_s,m4_s,mem_w,alu_opcode);
	input clk, rst;
	input S, Z, C, V;
	input [15:0] instruction;
	output alu_e,ar_e,br_e,dr_e,mdr_e,ir_e, genr_e, genr_w, pc_e,mem_e,m1_s,m2_s,m3_s,m4_s, m5_s, mem_w; // signal for general register
	output [5:0] alu_instruction; // ALU制御部へ

	reg [2:0] state; // phaseを表す
	reg [1:0] op;
	reg [2:0] r1;
	reg [2:0] r2;
	reg [3:0] opcode;
	reg [3:0] d4;
	reg [7:0] d8;
	reg [4:0] situ; // situation
	
	
	
	always @(posedge clk or negedge rst) begin
		op     <= instruction[15:14]; // op1
		r1     <= instruction[13:11]; // register 1
		r2     <= instruction[10:8]; // register 2
		alu_op <= instruction[7:4]; // opcode (op3) of alu
		d4     <= instruction[3:0]; // for shifter
		d8     <= instruction[7:0]; // for load, store, condition
		alu_instruction = instruction[15:10];
		
		// ALU
		if(op==2'b11)begin
			situ <= {0,alu_op}
			// case(alu_op)
			// 	4'b0000: situ <= 5'b00000; //ADD
			// 	4'b0001: situ <= 5'b00001; //SUB
			// 	4'b0010: situ <= 5'b00010; //AND
			// 	4'b0011: situ <= 5'b00011; //OR
			// 	4'b0100: situ <= 5'b00100; //XOR
			// 	4'b0101: situ <= 5'b00101; //CMP
			// 	4'b0110: situ <= 5'b00110; //MOV
			// 	4'b0111: situ <= 5'b00111; //reserved
			// 	4'b1000: situ <= 5'b01000; //SLL
			// 	4'b1001: situ <= 5'b01001; //SLR
			// 	4'b1010: situ <= 5'b01010; //SRL
			// 	4'b1011: situ <= 5'b01011; //SRA
			// else if(alu_op==4'b1100) //IN
			// 	situ <= 5'b01100;
			// else if(alu_op==4'b1101) //OUT
			// 	situ <= 5'b01101;
			// else if(alu_op==4'b1110) //reserved
			// 	situ <= 5'b01110;
			// else if(alu_op==4'b1111) //HLT
			// 	situ <= 5'b01111;
		end
		
		if(op==2'b00) //LD  r[Ra]=*(r[Rb]+sign_ext(d))
			situ <= 5'b10000;
		if(op==2'b01) //ST  *(r[Rb]+sign_ext(d))=r[Ra]
			situ <= 5'b10001;

		if(op==2'b10)begin
			if(r1==3'b000) //LI r[Rb]=sign_ext(d)
				situ <= 5'b10010;
			else if(r1==3'b100) //PC=PC+1+sign_ext(d)
				situ <= 5'b10011;
			else if(r1==3'b111)begin
				if(r2==3'b000 & Z==1'b1) //PC=PC+1+sign_ext(d)
					situ <= 5'b10100;
				else if(r2==3'b001 & S^V==1'b1) //PC=PC+1+sign_ext(d)
					situ <= 5'b10101;
				else if(r2==3'b010 & (Z||(S^V)==1)) //PC=PC+1+sign_ext(d)
					situ <= 5'b10110;
				else if(r2==3'b011 & (~Z==1'b1)) //PC=PC+	+sing_ext(d)
					situ <= 5'b10111;
			end
		end
				
			
		
		if(rst==1'b0) state <= 3'b000;

		
			case(state) //初期
				3'b000:begin
					state <= 3'b001; //次のphaseに行く
					alu_e  = 0
					ar_e   = 0
					br_e   = 0
					dr_e   = 0
					mdr_e  = 0
					ir_e   = 0
					genr_e = 0
					genr_w = 0
					pc_e   = 0
					mem_e  = 0
					mem_w  = 0
					m1_s   = 0
					m2_s   = 0
					m3_s   = 0
					m4_s   = 0
					m5_s   = 2'b00
				end
				3'b001:begin //RAMread
					state<=3'b010;
					// decode<=18'b000000011000000001;
					alu_e  = 0
					ar_e   = 0
					br_e   = 0
					dr_e   = 0
					mdr_e  = 0
					ir_e   = 0
					genr_e = 0
					genr_w = 0
					pc_e   = 0
					mem_e  = 1
					mem_w  = 0
					m1_s   = 0
					m2_s   = 0
					m3_s   = 0
					m4_s   = 0
				end
				3'b010:begin //IRread P1 命令フェッチ
					state<=3'b011;
					// decode<=18'b000001011000000001; // ?? why mem_w = 1?
					alu_e  = 0
					ar_e   = 0
					br_e   = 0
					dr_e   = 0
					mdr_e  = 0
					ir_e   = 1
					genr_e = 0
					genr_w = 0 // ?? but depends on the specific instruction. e.g. nothing is needed for 条件分岐
					pc_e   = 1
					mem_e  = 1
					mem_w  = 0
					m1_s   = 0
					m2_s   = 0
					m3_s   = 0
					m4_s   = 0
				end
				3'b011:begin //P2　命令デコード、レジスタ読み出し
					state<=3'b100;
					case(situ)
						5'b00000:begin //ADD
							alu_e  = 0
							ar_e   = 1
							br_e   = 1
							dr_e   = 0
							mdr_e  = 0
							ir_e   = 0
							genr_e = 1
							genr_w = 0
							pc_e   = 0
							mem_e  = 0
							mem_w  = 0
							m1_s   = 0
							m2_s   = 0
							m3_s   = 0
							m4_s   = 0
						end
						5'b00001:begin //SUB
							alu_e  = 1
							ar_e   = 1
							br_e   = 1
							dr_e   = 1
							mdr_e  = 0
							ir_e   = 0
							genr_e = 1
							genr_w = 0
							pc_e   = 0
							mem_e  = 0
							mem_w  = 0
							m1_s   = 0
							m2_s   = 0
							m3_s   = 0
							m4_s   = 0
						end
						5'b00010:begin //AND
							decode<=
						end
						5'b00011:begin //OR
							decode<=
						end
						5'b00100:begin //XOR
							decode<=
						end
						5'b00101:begin //CMP
							decode<=
						end
						5'b00110:begin //MOV
							decode<=
						end
						5'b00111:begin //reserved
							decode<=
						end
						5'b01000:begin //SLL
							decode<=
						end
						5'b01001:begin //SLR
							decode<=
						end
						5'b01010:begin //SRL
							decode<=
						end
						5'b01011:begin //SRA
							decode<=
						end
						5'b01100:begin //IN
							decode<=
						end
						5'b01101:begin //OUT
							decode<=
						end
						5'b01110:begin //reserved
							decode<=
						end
						5'b01111:begin //HLT
							decode<=
						end
						5'b10000:begin //LD  r[Ra]=*(r[Rb]+sign_ext(d))
							decode<=
						end
						5'b10001:begin //ST  *(r[Rb]+sign_ext(d))=r[Ra]
							decode<=
						end
						5'b10010:begin //LI r[Rb]=sign_ext(d)
							decode<=
						end
						5'b10011:begin //PC=PC+1+sign_ext(d) 
							decode<=
						end
						5'b10100:begin //PC=PC+1+sign_ext(d)
							decode<=
						end
						5'b10101:begin //PC=PC+1+sign_ext(d)
							decode<=
						end
						5'b10110:begin //PC=PC+1+sign_ext(d)
							decode<=
						end
						5'b10111:begin //PC=PC+1+sign_ext(d)
							decode<=
						end
					end
				3'b100:begin //P3　演算
					state<=3'b101;
					case(situ)
						5'b00000:begin //ADD
							alu_e  = 1
							ar_e   = 1
							br_e   = 1
							dr_e   = 1
							mdr_e  = 0
							ir_e   = 0
							genr_e = 0
							genr_w = 0
							pc_e   = 0
							mem_e  = 0
							mem_w  = 0
							m1_s   = 0
							m2_s   = 0
							m3_s   = 0
							m4_s   = 0
						end
						5'b00001:begin //SUB
							decode<=
						end
						5'b00010:begin //AND
							decode<=
						end
						5'b00011:begin //OR
							decode<=
						end
						5'b00100:begin //XOR
							decode<=
						end
						5'b00101:begin //CMP
							decode<=
						end
						5'b00110:begin //MOV
							decode<=
						end
						5'b00111:begin //reserved
							decode<=
						end
						5'b01000:begin //SLL
							decode<=
						end
						5'b01001:begin //SLR
							decode<=
						end
						5'b01010:begin //SRL
							decode<=
						end
						5'b01011:begin //SRA
							decode<=
						end
						5'b01100:begin //IN
							decode<=
						end
						5'b01101:begin //OUT
							decode<=
						end
						5'b01110:begin //reserved
							decode<=
						end
						5'b01111:begin //HLT
							decode<=
						end
						5'b10000:begin //LD  r[Ra]=*(r[Rb]+sign_ext(d))
							decode<=
						end
						5'b10001:begin //ST  *(r[Rb]+sign_ext(d))=r[Ra]
							decode<=
						end
						5'b10010:begin //LI r[Rb]=sign_ext(d)
							decode<=
						end
						5'b10011:begin //PC=PC+1+sign_ext(d) 
							decode<=
						end
						5'b10100:begin //PC=PC+1+sign_ext(d)
							decode<=
						end
						5'b10101:begin //PC=PC+1+sign_ext(d)
							decode<=
						end
						5'b10110:begin //PC=PC+1+sign_ext(d)
							decode<=
						end
						5'b10111:begin //PC=PC+1+sign_ext(d)
							decode<=
						end
					end
				3'b101:begin //P4　主記憶アクセス
					state<=3'b110;
					case(situ)
						5'b00000:begin //ADD
							alu_e  = 0
							ar_e   = 1
							br_e   = 1
							dr_e   = 0
							mdr_e  = 0
							ir_e   = 0
							genr_e = 1
							genr_w = 0
							pc_e   = 0
							mem_e  = 0
							mem_w  = 0
							m1_s   = 0
							m2_s   = 0
							m3_s   = 0
							m4_s   = 0
						end
						5'b00001:begin //SUB
							decode<=
						end
						5'b00010:begin //AND
							decode<=
						end
						5'b00011:begin //OR
							decode<=
						end
						5'b00100:begin //XOR
							decode<=
						end
						5'b00101:begin //CMP
							decode<=
						end
						5'b00110:begin //MOV
							decode<=
						end
						5'b00111:begin //reserved
							decode<=
						end
						5'b01000:begin //SLL
							decode<=
						end
						5'b01001:begin //SLR
							decode<=
						end
						5'b01010:begin //SRL
							decode<=
						end
						5'b01011:begin //SRA
							decode<=
						end
						5'b01100:begin //IN
							decode<=
						end
						5'b01101:begin //OUT
							decode<=
						end
						5'b01110:begin //reserved
							decode<=
						end
						5'b01111:begin //HLT
							decode<=
						end
						5'b10000:begin //LD  r[Ra]=*(r[Rb]+sign_ext(d))
							decode<=
						end
						5'b10001:begin //ST  *(r[Rb]+sign_ext(d))=r[Ra]
							decode<=
						end
						5'b10010:begin //LI r[Rb]=sign_ext(d)
							decode<=
						end
						5'b10011:begin //PC=PC+1+sign_ext(d) 
							decode<=
						end
						5'b10100:begin //PC=PC+1+sign_ext(d)
							decode<=
						end
						5'b10101:begin //PC=PC+1+sign_ext(d)
							decode<=
						end
						5'b10110:begin //PC=PC+1+sign_ext(d)
							decode<=
						end
						5'b10111:begin //PC=PC+1+sign_ext(d)
							decode<=
						end
					end
				3'b110:begin //P5　レジスタ書き込み　PC更新
					state<=3'b011;
					case(situ)
						5'b00000:begin //ADD
							decode<=
						end
						5'b00001:begin //SUB
							decode<=
						end
						5'b00010:begin //AND
							decode<=
						end
						5'b00011:begin //OR
							decode<=
						end
						5'b00100:begin //XOR
							decode<=
						end
						5'b00101:begin //CMP
							decode<=
						end
						5'b00110:begin //MOV
							decode<=
						end
						5'b00111:begin //reserved
							decode<=
						end
						5'b01000:begin //SLL
							decode<=
						end
						5'b01001:begin //SLR
							decode<=
						end
						5'b01010:begin //SRL
							decode<=
						end
						5'b01011:begin //SRA
							decode<=
						end
						5'b01100:begin //IN
							decode<=
						end
						5'b01101:begin //OUT
							decode<=
						end
						5'b01110:begin //reserved
							decode<=
						end
						5'b01111:begin //HLT
							decode<=
						end
						5'b10000:begin //LD  r[Ra]=*(r[Rb]+sign_ext(d))
							decode<=
						end
						5'b10001:begin //ST  *(r[Rb]+sign_ext(d))=r[Ra]
							decode<=
						end
						5'b10010:begin //LI r[Rb]=sign_ext(d)
							decode<=
						end
						5'b10011:begin //PC=PC+1+sign_ext(d) 
							decode<=
						end
						5'b10100:begin //PC=PC+1+sign_ext(d)
							decode<=
						end
						5'b10101:begin //PC=PC+1+sign_ext(d)
							decode<=
						end
						5'b10110:begin //PC=PC+1+sign_ext(d)
							decode<=
						end
						5'b10111:begin //PC=PC+1+sign_ext(d)
							decode<=
						end
					endcase
					end
					end



					endmodule
				
				