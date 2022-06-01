module alu( opcode,d, alu_in_a, alu_in_b, alu_out, S,Z,C,V);

	input [3:0] opcode;
	input [15:0] alu_in_a;
	input  [15:0] alu_in_b;
	input [3:0] d;
	output [15:0] alu_out;
	output S;
	output Z;

	output C;
	output V;
	
	wire [16:0] SUM;
	wire [16:0] SUB;
	wire [15:0] AND;
	wire [15:0] OR;
	wire [15:0] XOR;
	wire c;
	assign c=alu_in_b[15];

	function [15:0]SLR;
		input [15:0] alu_in_b;  //a wo b ni kaeta
		
		input [3:0] D; // d 4 bit takes values 0 to 16
		begin
			case(D)
				4'b0000:SLR=alu_in_b[15:0];   // a wo b ni kaeta
				4'b0001:SLR={alu_in_b[14:0], alu_in_b[15:15]};
				4'b0010:SLR={alu_in_b[13:0], alu_in_b[15:14]};
				4'b0011:SLR={alu_in_b[12:0], alu_in_b[15:13]};
				4'b0100:SLR={alu_in_b[11:0], alu_in_b[15:12]};
				4'b0101:SLR={alu_in_b[10:0], alu_in_b[15:11]};
				4'b0110:SLR={alu_in_b[9:0], alu_in_b[15:10]};
				4'b0111:SLR={alu_in_b[8:0], alu_in_b[15:9]};
				4'b1000:SLR={alu_in_b[7:0], alu_in_b[15:8]};
				4'b1001:SLR={alu_in_b[6:0], alu_in_b[15:7]};
				4'b1010:SLR={alu_in_b[5:0], alu_in_b[15:6]};
				4'b1011:SLR={alu_in_b[4:0], alu_in_b[15:5]};
				4'b1100:SLR={alu_in_b[3:0], alu_in_b[15:4]};
				4'b1101:SLR={alu_in_b[2:0], alu_in_b[15:3]};
				4'b1110:SLR={alu_in_b[1:0], alu_in_b[15:2]};
				4'b1111:SLR={alu_in_b[0:0], alu_in_b[15:1]};
			endcase
		end
	endfunction
	
	
	function [15:0]SRA;
		input [15:0] alu_in_b;
		input [3:0] D;
		input c;
		begin
			case(D)
				4'b0000:SRA=alu_in_b[15:0];
				4'b0001:SRA={c,alu_in_b[15:1]};
				4'b0010:SRA={c,c,alu_in_b[15:2]};
				4'b0011:SRA={c,c,c,alu_in_b[15:3]};
				4'b0100:SRA={c,c,c,c,alu_in_b[15:4]};
				4'b0101:SRA={c,c,c,c,c,alu_in_b[15:5]};
				4'b0110:SRA={c,c,c,c,c,c,alu_in_b[15:6]};
				4'b0111:SRA={c,c,c,c,c,c,c,alu_in_b[15:7]};
				4'b1000:SRA={c,c,c,c,c,c,c,c,alu_in_b[15:8]};
				4'b1001:SRA={c,c,c,c,c,c,c,c,c,alu_in_b[15:9]};
				4'b1010:SRA={c,c,c,c,c,c,c,c,c,c,alu_in_b[15:10]};
				4'b1011:SRA={c,c,c,c,c,c,c,c,c,c,c,alu_in_b[15:11]};
				4'b1100:SRA={c,c,c,c,c,c,c,c,c,c,c,c,alu_in_b[15:12]};
				4'b1101:SRA={c,c,c,c,c,c,c,c,c,c,c,c,c,alu_in_b[15:13]};
				4'b1110:SRA={c,c,c,c,c,c,c,c,c,c,c,c,c,c,alu_in_b[15:14]};
				4'b1111:SRA={c,c,c,c,c,c,c,c,c,c,c,c,c,c,c,alu_in_b[15]};
			endcase
		end
	endfunction
				
	wire shift;
	wire [16:0] alu_intermediate;
	
	assign ADD={1'b0, alu_in_a }+{1'b0, alu_in_b};
	assign shift=8*d[3]+4*d[2]+2*d[1]+d[0];
	assign alu_intermediate=(opcode==4'b0000) ? alu_in_a +alu_in_b:
								(opcode==4'b0001) ? alu_in_b-alu_in_a:
								(opcode==4'b0010) ? alu_in_a & alu_in_b:
								(opcode==4'b0011) ? alu_in_a | alu_in_b:
								(opcode==4'b0100) ? alu_in_a ^ alu_in_b:
								(opcode==4'b0110) ? alu_in_a:    //b wo a ni kaeta
								(opcode==4'b0111) ? 16'b0000000000000000:
								(opcode==4'b1000) ? alu_in_b<<d:   //a wo b ni kaeta 
								(opcode==4'b1001) ? SLR(alu_in_b,d):
								(opcode==4'b1010) ? alu_in_b>>d:
								(opcode==4'b1011) ? SRA(alu_in_b,d,c):  //alu_in_b>>>d:
								16'b0000000000000000;
	
	assign Z=(alu_intermediate==16'b0000000000000000)? 1'b1:1'b0;
	assign S=(alu_intermediate[15]==1'b1)?1'b1:1'b0;
	
				
	assign V=(opcode==4'b0000) ? ((alu_in_a[15]^alu_in_b[15]==0)&&(alu_in_b[15]^alu_intermediate[15]==1))?1'b1:1'b0:
				(opcode==4'b0001) ? ((alu_in_a[15]^alu_in_b[15]==1)&&(alu_in_b[15]^alu_intermediate[15]==1))?1'b1:1'b0:
				(opcode==4'b0010) ? 1'b0:
				(opcode==4'b0011) ? 1'b0:
				(opcode==4'b0100) ? 1'b0:
				(opcode==4'b0101) ? ((alu_in_a[15]^alu_in_b[15]==1)&&(alu_in_b[15]^alu_intermediate[15]==1))?1'b1:1'b0: // CMP
				(opcode==4'b0110) ? 1'b0:
				(opcode==4'b0111) ? 1'b0:
				(opcode==4'b1000) ? 1'b0: // shift
				(opcode==4'b1001) ? 1'b0:
				(opcode==4'b1010) ? 1'b0:
				(opcode==4'b1011) ? 1'b0:
				1'b0;
	
	
	
			
	assign C=(opcode==4'b0000) ? alu_intermediate[16]: //最上位ビットからの桁上げ
				(opcode==4'b0001) ? alu_intermediate[16]:
				(opcode==4'b0010) ? 1'b0: // AND, OR, XOR結果に関わらず０
				(opcode==4'b0011) ? 1'b0:
				(opcode==4'b0100) ? 1'b0:
				(opcode==4'b0101) ? alu_intermediate[16]: // CMP
				(opcode==4'b0110) ? 1'b0: // MOV
				(opcode==4'b0111) ? 1'b0: // reserved
				(opcode==4'b1000) ? alu_in_b[16-d]:      // a wo b nikaeta
				(opcode==4'b1001) ? 1'b0: // SLR --> 0
				(opcode==4'b1010) ? alu_in_b[d-1]:
				(opcode==4'b1011) ? alu_in_b[d-1]:    
				1'b0;
				
	assign alu_out = alu_intermediate[15:0];

	endmodule
	
	
		
		

		
		
		
		