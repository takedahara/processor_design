module control(clk,rst,S,Z,C,V,meirei,alu_e,ar_e,br_e,dr_e,mr_e,ir_e,pc_e,
mem_e,m1_s,m2_s,m3_s,m4_s,mem_w,alu_opcode);
	input clk;
	input rst;
	input S;
	input Z;
	input C;
	input V;
	input [15:0] meirei;
	output alu_e,ar_e,br_e,dr_e,mr_e,ir_e,pc_e,
mem_e,m1_s,m2_s,m3_s,m4_s,mem_w,m5_s;
	output [3:0] alu_opcode;
	reg [17:0] decode;
	reg [2:0] state;
	reg [1:0] op;
	reg [2:0] r1;
	reg [2:0] r2;
	reg [3:0] opcode;
	reg [3:0] d4;
	reg [7:0] d8;
	reg [4:0] situ;
	
	
	
	always @(posedge clk or negedge rst)begin
	
		op=meirei[15:14];
		r1=meirei[13:11];
		r2=meirei[10:8];
		opcode=meirei[7:4];
		d4=meirei[3:0];
		d8=meirei[7:0];
		
		if(op==2'b11)begin
			if(opcode==4'b0000)begin //ADD
				situ=5'b00000;
				end
			else if(opcode==4'b0001)begin //SUB
				situ=5'b00001;
				end
			else if(opcode==4'b0010)begin //AND
				situ=5'b00010;
				end
			else if(opcode==4'b0011)begin //OR
				situ=5'b00011;
				end
			else if(opcode==4'b0100)begin //XOR
				situ=5'b00100;
				end
			else if(opcode==4'b0101)begin //CMP
				situ=5'b00101;
				end
			else if(opcode==4'b0110)begin //MOV
				situ=5'b00110;
				end
			else if(opcode==4'b0111)begin //reserved
				situ=5'b00111;
				end
			else if(opcode==4'b1000)begin //SLL
				situ=5'b01000;
				end
			else if(opcode==4'b1001)begin //SLR
				situ=5'b01001;
				end
			else if(opcode==4'b1010)begin //SRL
				situ=5'b01010;
				end
			else if(opcode==4'b1011)begin //SRA
				situ=5'b01011;
				end
			else if(opcode==4'b1100)begin //IN
				situ=5'b01100;
				end
			else if(opcode==4'b1101)begin //OUT
				situ=5'b01101;
				end
			else if(opcode==4'b1110)begin //reserved
				situ=5'b01110;
				end
			else if(opcode==4'b1111)begin //HLT
				situ=5'b01111;
				end
				end
		
		if(op==2'b00)begin //LD  r[Ra]=*(r[Rb]+sign_ext(d))
			situ=5'b10000;
			end
		if(op==2'b01)begin //ST  *(r[Rb]+sign_ext(d))=r[Ra]
			situ=5'b10001;
			end
		if(op==2'b10)begin
			if(r1==3'b000)begin //LI r[Rb]=sign_ext(d)
				situ=5'b10010;
				end
			else if(r1==3'b100)begin //PC=PC+1+sign_ext(d)
				situ=5'b10011;
				end
			else if(r1==3'b111)begin
				if(r2==3'b000&Z==1'b1)begin //PC=PC+1+sign_ext(d)
					situ=5'b10100;
					end
				else if(r2==3'b001&S^V==1'b1)begin //PC=PC+1+sign_ext(d)
					situ=5'b10101;
					end
				else if(r2==3'b010&(Z||(S^V)==1))begin //PC=PC+1+sign_ext(d)
					situ=5'b10110;
					end
				else if(r2==3'b011&(~Z==1'b1))begin //PC=PC+	+sing_ext(d)
					situ=5'b10111;
					end
				
				
			
		
		if(rst==1'b0)
			state<=3'b000;
		else
			
			
			
			
			case(state) //初期
				3'b000:begin
					state<=3'b001;
					decode<=18'b000000000000000000;
				end
				3'b001:begin //RAMread
					state<=3'b010;
					decode<=18'b000000011000000001;
				end
				3'b010:begin //IRread P1 命令フェッチ
					state<=3'b011;
					decode<=18'b000001011000000001;
				end
				3'b011:begin //P2　命令デコード、レジスタ読み出し
					state<=3'b100;
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
					end
				3'b100:begin //P3　演算
					state<=3'b101;
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
					end
				3'b101:begin //P4　主記憶アクセス
					state<=3'b110;
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
					end
					end
					endmodule
				
				