module alu(alu_e, rst, opcode,d, alu_in_a, alu_in_b, alu_out, S,Z,C,
V);
	input alu_e;
	input rst;
	input [3:0] opcode;
	input [15:0] alu_in_a;
	input [15:0] alu_in_b;
	input [3:0] d;
	output [15:0] alu_out;
	output S;
	output Z;
	output C;
	output V;
	reg[15:0] alu_out;
	reg S;
	reg Z;
	reg C;
	reg V;
	reg [16:0] SUM;
	reg [16:0] SUB;
	reg [15:0] AND;
	reg [15:0] OR;
	reg [15:0] XOR;
	
	reg shift;
	
	
	
	always @(posedge alu_e or negedge rst) begin
		if(!rst)begin
			alu_out <= 8'b00000000;
		end else begin
			case(opcode)
				
			4'b0000: begin
				{C, alu_out} <={1'b0, alu_in_a }+{1'b0, alu_in_b};	// ADD
				if( (alu_in_a + alu_in_b) == 16'b0000000000000000 )
					Z <=1;
				else
					Z <=0;
				
				SUM={1'b0,alu_in_a}+{1'b0,alu_in_b};
				S<=SUM[15];
				V<=SUM[16];
				end
				
			4'b0001: begin
				{C,alu_out} <= {1'b0,alu_in_a} +{1'b0, ~(alu_in_b)}+17'b00000000000000001;		// SUB
				if({1'b0,alu_in_a} +{1'b0, ~(alu_in_b)}+17'b00000000000000001== 17'b0000000000000000 
				|{1'b0,alu_in_a} +{1'b0, ~(alu_in_b)}+17'b00000000000000001== 17'b1000000000000000)
					Z <= 1'b1;
				else
					Z <= 1'b0;
					
				SUB={1'b0,alu_in_a} +{1'b0, ~(alu_in_b)}+17'b00000000000000001;
				S<=SUB[15];
				V<=SUB[16];
				end
			4'b0010: begin
				alu_out <= alu_in_a & alu_in_b;		// AND
				if( (alu_in_a & alu_in_b) == 16'b0000000000000000 )
					Z <= 1'b1;
				else
					Z <= 1'b0;
				AND=alu_in_a & alu_in_b;
				S<=AND[15];
				V<=0;
				C<=0;
				end
			4'b0011: begin
				alu_out <= alu_in_a | alu_in_b;		// OR
				if( (alu_in_a | alu_in_b) == 16'b0000000000000000 )
					Z <= 1'b1;
				else
					Z <= 1'b0;
				OR=alu_in_a | alu_in_b;
				S<=OR[15];
				V<=0;
				C<=0;
				end
			4'b0100: begin									// XOR
				alu_out <= alu_in_a ^ alu_in_b;
				if( (alu_in_a ^ alu_in_b) == 15'b0000000000000000 )
					Z <= 1'b1;
				else
					Z <= 1'b0;
				XOR=alu_in_a ^ alu_in_b;
				S<=XOR[15];
				V<=0;
				C<=0;
				end
			4'b0101: begin //CMP
				if({1'b0,alu_in_a} +{1'b0, ~(alu_in_b)}+17'b00000000000000001== 17'b0000000000000000 
				|{1'b0,alu_in_a} +{1'b0, ~(alu_in_b)}+17'b00000000000000001== 17'b1000000000000000 )
					Z <= 1'b1;
				else
					Z <= 1'b0;
				
				S<=SUB[15];
				V<=SUB[16];
				C<=SUB[16];
				end
			4'b0110: begin //MOV
				alu_out<=alu_in_b;
				C<=0;
				V<=0;
				S<=alu_in_b[15];
				if(alu_in_b==16'b0000000000000000)
					Z<=1;
				else 
					Z<=0;
				end
    		4'b0111: begin //reserved
				
				end
			4'b1000: begin //SLL
				shift=8*d[3]+4*d[2]+2*d[1]+d[0];
				alu_out <= (alu_in_a<<shift);	
				V<=0;
				if(shift==0) 
					C<=0;
				else if(shift==1) begin
					C<=alu_in_a[15];
					S<=alu_in_a[14];
					if(alu_in_a[14:0]==15'b000000000000000) 
						Z<=0;
					else 
						Z<=1;
					end
				else if(shift==2) begin
					C<=alu_in_a[14];
					S<=alu_in_a[13];
					if(alu_in_a[13:0]==14'b00000000000000)
						Z<=0;
					else
						Z<=1;
					end
				else if(shift==3) begin
					C<=alu_in_a[13];
					S<=alu_in_a[12];
					if(alu_in_a[12:0]==13'b0000000000000) 
						Z<=0;
					else 
						Z<=1;
					end
				else if(shift==4) begin
					C<=alu_in_a[12];
					S<=alu_in_a[11];
					if(alu_in_a[11:0]==12'b000000000000)
						Z<=0;
					else
						Z<=1;
					end
				else if(shift==5) begin
					C<=alu_in_a[11];
					S<=alu_in_a[10];
					if(alu_in_a[10:0]==11'b00000000000) 
						Z<=0;
					else 
						Z<=1;
					end
				else if(shift==6) begin
					C<=alu_in_a[10];
					S<=alu_in_a[9];
					if(alu_in_a[9:0]==10'b0000000000)
						Z<=0;
					else
						Z<=1;
					end
				else if(shift==7) begin
					C<=alu_in_a[9];
					S<=alu_in_a[8];
					if(alu_in_a[8:0]==9'b000000000) 
						Z<=0;
					else 
						Z<=1;
					end
				else if(shift==8) begin
					C<=alu_in_a[8];
					S<=alu_in_a[7];
					if(alu_in_a[7:0]==8'b00000000)
						Z<=0;
					else
						Z<=1;
					end
				else if(shift==9) begin
					C<=alu_in_a[7];
					S<=alu_in_a[6];
					if(alu_in_a[6:0]==7'b0000000) 
						Z<=0;
					else 
						Z<=1;
					end
				else if(shift==10) begin
					C<=alu_in_a[6];
					S<=alu_in_a[5];
					if(alu_in_a[5:0]==6'b000000)
						Z<=0;
					else
						Z<=1;
					end
				else if(shift==11) begin
					C<=alu_in_a[5];
					S<=alu_in_a[4];
					if(alu_in_a[4:0]==5'b00000) 
						Z<=0;
					else 
						Z<=1;
					end
				else if(shift==12) begin
					C<=alu_in_a[4];
					S<=alu_in_a[3];
					if(alu_in_a[3:0]==4'b0000)
						Z<=0;
					else
						Z<=1;
					end
				else if(shift==13) begin
					C<=alu_in_a[3];
					S<=alu_in_a[2];
					if(alu_in_a[2:0]==3'b000) 
						Z<=0;
					else 
						Z<=1;
					end
				else if(shift==14) begin
					C<=alu_in_a[2];
					S<=alu_in_a[1];
					if(alu_in_a[1:0]==2'b00)
						Z<=0;
					else
						Z<=1;
					end
				else if(shift==15) begin
					C<=alu_in_a[1];
					S<=alu_in_a[0];
					if(alu_in_a[0:0]==1'b0) 
						Z<=0;
					else 
						Z<=1;
					end
				
					
				
				end
         4'b1001: begin //SLR
				shift=8*d[3]+4*d[2]+2*d[1]+d[0];
				C<=0;
				V<=0;
				if(alu_in_a==16'b0000000000000000)
					Z<=1;
				else
					Z<=0;
				if(shift==0) begin
					alu_out <= alu_in_a[15:0];
				end
				
				else if(shift==1) begin
					alu_out <={alu_in_a[14:0], alu_in_a[15:15]};
					S<=alu_in_a[14];
				end
				else if(shift==2) begin
					alu_out <={alu_in_a[13:0], alu_in_a[15:14]};
					S<=alu_in_a[13];
				end
				else if(shift==3) begin
					alu_out <={alu_in_a[12:0], alu_in_a[15:13]};
					S<=alu_in_a[12];
				end
				else if(shift==4) begin
					alu_out <={alu_in_a[11:0], alu_in_a[15:12]};
					S<=alu_in_a[11];
				end
				else if(shift==5) begin
					alu_out <={alu_in_a[10:0], alu_in_a[15:11]};
					S<=alu_in_a[10];
				end
				else if(shift==6) begin
					alu_out <={alu_in_a[9:0], alu_in_a[15:10]};
					S<=alu_in_a[9];
				end
				else if(shift==7) begin
					alu_out <={alu_in_a[8:0], alu_in_a[15:9]};
					S<=alu_in_a[8];
				end
				else if(shift==8) begin
					alu_out <={alu_in_a[7:0], alu_in_a[15:8]};
					S<=alu_in_a[7];
				end
				else if(shift==9) begin
					alu_out <={alu_in_a[6:0], alu_in_a[15:7]};
					S<=alu_in_a[6];
				end
				else if(shift==10) begin
					S<=alu_in_a[5];
					alu_out <={alu_in_a[5:0], alu_in_a[15:6]};
				end
				else if(shift==11) begin
					alu_out <={alu_in_a[4:0], alu_in_a[15:5]};
					S<=alu_in_a[4];
				end
				else if(shift==12) begin
					alu_out <={alu_in_a[3:0], alu_in_a[15:4]};
					S<=alu_in_a[3];
				end
				else if(shift==13) begin
					alu_out <={alu_in_a[2:0], alu_in_a[15:3]};
					S<=alu_in_a[2];
				end
				else if(shift==14) begin
					alu_out <={alu_in_a[1:0], alu_in_a[15:2]};
					S<=alu_in_a[1];
				end
				else if(shift==15) begin
					alu_out <={alu_in_a[0:0], alu_in_a[15:1]};
					S<=alu_in_a[0];
				end
				
				
				end
			4'b1010: begin
				shift=8*d[3]+4*d[2]+2*d[1]+d[0];
				alu_out <= (alu_in_a>>shift); //SRL
				V<=0;
				if(shift==0) begin
					C<=0;
				end
				else if(shift==1) begin
					C<=alu_in_a[0];
					S<=0;
					if(alu_in_a[15:1]==15'b000000000000000)
						Z<=1;
					else
						Z<=0;
				end
				else if(shift==2) begin
					C<=alu_in_a[1];
					S<=0;
					if(alu_in_a[15:2]==14'b00000000000000)
						Z<=1;
					else
						Z<=0;
				end
				else if(shift==3) begin
					C<=alu_in_a[2];
					S<=0;
					if(alu_in_a[15:3]==13'b0000000000000)
						Z<=1;
					else
						Z<=0;
				end
				else if(shift==4) begin
					C<=alu_in_a[3];
					S<=0;
					if(alu_in_a[15:4]==12'b000000000000)
						Z<=1;
					else
						Z<=0;
				end
				else if(shift==5) begin
					C<=alu_in_a[4];
					S<=0;
					if(alu_in_a[15:5]==11'b00000000000)
						Z<=1;
					else
						Z<=0;
				end
				else if(shift==6) begin
					C<=alu_in_a[5];
					S<=0;
					if(alu_in_a[15:6]==10'b0000000000)
						Z<=1;
					else
						Z<=0;
				end
				else if(shift==7) begin
					C<=alu_in_a[6];
					S<=0;
					if(alu_in_a[15:7]==9'b000000000)
						Z<=1;
					else
						Z<=0;
				end
				else if(shift==8) begin
					C<=alu_in_a[7];
					S<=0;
					if(alu_in_a[15:8]==8'b00000000)
						Z<=1;
					else
						Z<=0;
				end
				else if(shift==9) begin
					C<=alu_in_a[8];
					S<=0;
					if(alu_in_a[15:9]==7'b0000000)
						Z<=1;
					else
						Z<=0;
				end
				else if(shift==10) begin
					C<=alu_in_a[9];
					S<=0;
					if(alu_in_a[15:10]==6'b000000)
						Z<=1;
					else
						Z<=0;
				end
				else if(shift==11) begin
					C<=alu_in_a[10];
					S<=0;
					if(alu_in_a[15:11]==5'b00000)
						Z<=1;
					else
						Z<=0;
				end
				else if(shift==12) begin
					C<=alu_in_a[11];
					S<=0;
					if(alu_in_a[15:12]==4'b0000)
						Z<=1;
					else
						Z<=0;
				end
				else if(shift==13) begin
					C<=alu_in_a[12];
					S<=0;
					if(alu_in_a[15:13]==3'b000)
						Z<=1;
					else
						Z<=0;
				end
				else if(shift==14) begin
					C<=alu_in_a[13];
					S<=0;
					if(alu_in_a[15:14]==2'b00)
						Z<=1;
					else
						Z<=0;
				end
				else if(shift==15) begin
					C<=alu_in_a[14];
					S<=0;
					if(alu_in_a[15:15]==1'b0)
						Z<=1;
					else
						Z<=0;
				end
				
				
				
			
			end
			4'b1011: begin //SRA
				shift=8*d[3]+4*d[2]+2*d[1]+d[0];
				V<=0;
				if(alu_in_a==16'b0000000000000000)
					Z<=1;
				else 
					Z<=0;
				if(shift==0) begin
					alu_out <= alu_in_a[15:0];
					C<=0;
					S<=alu_in_a[15];
				end
				
				else if(shift==1) begin
					alu_out <={alu_in_a[0:0], alu_in_a[15:1]};
					C<=alu_in_a[0];
					S<=alu_in_a[0];
				end
				else if(shift==2) begin
					alu_out <={alu_in_a[1:0], alu_in_a[15:2]};
					C<=alu_in_a[1];
					S<=alu_in_a[1];
				end
				else if(shift==3) begin
					alu_out <={alu_in_a[2:0], alu_in_a[15:3]};
					C<=alu_in_a[2];
					S<=alu_in_a[2];
				end
				else if(shift==4) begin
					alu_out <={alu_in_a[3:0], alu_in_a[15:4]};
					C<=alu_in_a[3];
					S<=alu_in_a[3];
				end
				else if(shift==5) begin
					alu_out <={alu_in_a[4:0], alu_in_a[15:5]};
					C<=alu_in_a[4];
					S<=alu_in_a[4];
				end
				else if(shift==6) begin
					alu_out <={alu_in_a[5:0], alu_in_a[15:6]};
					C<=alu_in_a[5];
					S<=alu_in_a[5];
				end
				else if(shift==7) begin
					alu_out <={alu_in_a[6:0], alu_in_a[15:7]};
					C<=alu_in_a[6];
					S<=alu_in_a[6];
				end
				else if(shift==8) begin
					alu_out <={alu_in_a[7:0], alu_in_a[15:8]};
					C<=alu_in_a[7];
					S<=alu_in_a[7];
				end
				else if(shift==9) begin
					alu_out <={alu_in_a[8:0], alu_in_a[15:9]};
					C<=alu_in_a[8];
					S<=alu_in_a[8];
				end
				else if(shift==10) begin
					alu_out <={alu_in_a[9:0], alu_in_a[15:10]};
					C<=alu_in_a[9];
					S<=alu_in_a[9];
				end
				else if(shift==11) begin
					alu_out <={alu_in_a[10:0], alu_in_a[15:11]};
					C<=alu_in_a[10];
					S<=alu_in_a[10];
				end
				else if(shift==12) begin
					alu_out <={alu_in_a[11:0], alu_in_a[15:12]};
					C<=alu_in_a[11];
					S<=alu_in_a[11];
				end
				else if(shift==13) begin
					alu_out <={alu_in_a[12:0], alu_in_a[15:13]};
					C<=alu_in_a[12];
					S<=alu_in_a[12];
				end
				else if(shift==14) begin
					alu_out <={alu_in_a[13:0], alu_in_a[15:14]};
					C<=alu_in_a[13];
					S<=alu_in_a[13];
				end
				else if(shift==15) begin
					alu_out <={alu_in_a[14:0], alu_in_a[15:15]};
					C<=alu_in_a[14];
					S<=alu_in_a[14];
				end
				
				
				end
			
			 //SRA
			4'b1100: begin
				  alu_out <= alu_in_a; //IN
				  end
			4'b1101: alu_out <= alu_in_b;//OUT
			4'b1110: begin
		      end	//reserved
			4'b1111: begin
			   end//HLT
		
			default: alu_out <= 16'b0000000000000000;
			endcase
		end
		
	end

endmodule