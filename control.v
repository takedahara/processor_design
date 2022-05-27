module control(rst, phase,
				S,Z,C,V,
				instruction,
				aluc_e,
				ar_e,br_e,dr_e,mdr_e,ir_e, // enablers
                reg_e, // signal for all non-general registers --> 同期
				genr_w,
				//pc_e,
				mem_e, mem_w,
				jump,m2_s,m3_s,m4_s,m5_s, m6_s, m7_s, m8_s,out_s,hlt,
                alu_instruction);
	input rst;
   input [2:0] phase;
	input S, Z, C, V;
	input [15:0] instruction;
	output reg	aluc_e,
				ar_e,br_e,dr_e,mdr_e,ir_e, 
                reg_e,
				genr_w, 
				//pc_e,
				mem_e, mem_w, 
				jump,m2_s,m3_s,m4_s, m5_s, m6_s, m7_s, m8_s,out_s,hlt;
	output [5:0] alu_instruction; // ALU制御部へ
	 
	 wire [1:0] op = instruction[15:14];
	 wire [2:0] r1 = instruction[13:11];
	 wire [2:0] r2 = instruction[10:8];
	 wire [3:0] alu_op = instruction[7:4];
	 reg [4:0] command;

    // set the value of alu_instruction depending on the type of instruction
    // if(op==2'b11) alu_instruction <= { instruction[15:14], instruction[7:4] };
    // else alu_instruction <=  {instruction[15:10]};
    assign alu_instruction = (op==2'b11) ? { instruction[15:14], instruction[7:4] } : {instruction[15:10]};

    always @(*) begin
        // set the value of "command" depending on the instruction
        case(op)
            2'b11: command <= {1'b0,alu_op}; // ALU
            2'b00: command <= 5'b10000; //LD  r[Ra]=*(r[Rb]+sign_ext(d))
            2'b01: command <= 5'b10001; //ST  *(r[Rb]+sign_ext(d))=r[Ra]
            2'b10: begin
                case(r1)
                    3'b000: command <= 5'b10010; //LI r[Rb]=sign_ext(d)
                    3'b100: command <= 5'b10011; //B PC=PC+1+sign_ext(d)
                    3'b111: begin
                        case(r2)
                            3'b000: if(Z) command <= 5'b10100; //BE PC=PC+1+sign_ext(d)
                            3'b001: if (S^V) command <= 5'b10101; //BLT PC=PC+1+sign_ext(d)
                            3'b010: if (Z||(S^V)) command <= 5'b10110; //BLE PC=PC+1+sign_ext(d)
                            3'b011: if (!Z) command <= 5'b10111; //BNE PC=PC+1+sing_ext(d)
                        endcase
                    end
                endcase
            end
        endcase

        

        if (phase == 3'b000) begin // if reset or at phase 0
            aluc_e <= 0;
            ar_e   <= 0;
            br_e   <= 0;
            dr_e   <= 0;
            mdr_e  <= 0;
            ir_e   <= 0;
            reg_e  <= 0;
            
            // pc_e   <= 0;
            mem_e  <= 0;
            
            jump   <= 0;
            m2_s   <= 0;
            m3_s   <= 0;
            m4_s   <= 0;
            m5_s   <= 0;
            m6_s   <= 0;
            m7_s   <= 0;
            m8_s   <= 0;
        end else begin
            case(command)
                5'b00000, 5'b00001, 5'b00010, 5'b00011, 5'b00100: begin//ADD, SUB, AND, OR, XOR
                    aluc_e <= 1;
                    ar_e   <= 1;
                    br_e   <= 1;
                    dr_e   <= 1;
                    mdr_e  <= 0;
                    ir_e   <= 1;
                    reg_e  <= 1;
                    
                    // pc_e   <= 1;
                    mem_e  <= 1;
                    
                    jump   <= 0; // PC+1
                    m2_s   <= 0;
                    m3_s   <= 0;
                    m4_s   <= 0;
                    m5_s   <= 1;
                    m6_s   <= 0;
                    m7_s   <= 0;
                    m8_s   <= 0;
                    end
                5'b00101: begin//CMP
                    aluc_e <= 1;
                    ar_e   <= 1;
                    br_e   <= 1;
                    dr_e   <= 0;
                    mdr_e  <= 0;
                    ir_e   <= 1;
                    reg_e  <= 1;
                    
                    // pc_e   <= 0;
                    mem_e  <= 0;
                    
                    jump   <= 0;
                    m2_s   <= 0;
                    m3_s   <= 0;
                    m4_s   <= 0;
                    m5_s   <= 0;
                    m6_s   <= 0;
                    m7_s   <= 0;
                    m8_s   <= 0;
                    end
                5'b00110: begin //MOV
                    aluc_e <= 1;
                    ar_e   <= 0;
                    br_e   <= 0;
                    dr_e   <= 0;
                    mdr_e  <= 0;
                    ir_e   <= 1;
                    reg_e  <= 1;
                    
                    // pc_e   <= 0;
                    mem_e  <= 0;
                    
                    jump   <= 0;
                    m2_s   <= 0;
                    m3_s   <= 0;
                    m4_s   <= 0;
                    m5_s   <= 1;
                    m6_s   <= 0;
                    m7_s   <= 0;
                    m8_s   <= 0;
                    end
                5'b01000, 5'b01001, 5'b01010, 5'b01011: begin //SLL, SLR, SRL, SRA
                    aluc_e <= 1;
                    ar_e   <= 0;
                    br_e   <= 1;
                    dr_e   <= 1;
                    mdr_e  <= 0;
                    ir_e   <= 1;
                    reg_e  <= 1;
                    
                    // pc_e   <= 1;
                    mem_e  <= 1;
                    
                    jump   <= 0;
                    m2_s   <= 1; // d
                    m3_s   <= 0;
                    m4_s   <= 0;
                    m5_s   <= 1;
                    m6_s   <= 0;
                    m7_s   <= 0;
                    m8_s   <= 0;
                    end
                5'b01100: begin //IN
                    aluc_e <= 0;
                    ar_e   <= 0;
                    br_e   <= 0;
                    dr_e   <= 0;
                    mdr_e  <= 1;
                    ir_e   <= 1;
                    reg_e  <= 1;
                    
                    // pc_e   <= 1;
                    mem_e  <= 1;
                    
                    jump   <= 0;
                    m2_s   <= 0;
                    m3_s   <= 0;
                    m4_s   <= 1;
                    m5_s   <= 1;
                    m6_s   <= 0;
                    m7_s   <= 1;
                    m8_s   <= 0;
                    end
                5'b01101: begin //OUT
                    aluc_e <= 0;
                    ar_e   <= 1;
                    br_e   <= 0;
                    dr_e   <= 0;
                    mdr_e  <= 0;
                    ir_e   <= 1;
                    reg_e  <= 1;
                    
                    // pc_e   <= 1;
                    mem_e  <= 1;
                    
                    jump   <= 0;
                    m2_s   <= 0;
                    m3_s   <= 0;
                    m4_s   <= 0;
                    m5_s   <= 0;
                    m6_s   <= 0;
                    m7_s   <= 0;
                    m8_s   <= 0;
						  out_s<=1;
                    end
                5'b01111: begin //HLT
                    aluc_e <= 0;
                    ar_e   <= 0;
                    br_e   <= 0;
                    dr_e   <= 0;
                    mdr_e  <= 0;
                    ir_e   <= 0;
                    reg_e  <= 0;
                    
                    // pc_e   <= 0;
                    mem_e  <= 0;
                    
                    jump   <= 0;
                    m2_s   <= 0;
                    m3_s   <= 0;
                    m4_s   <= 0;
                    m5_s   <= 0;
                    m6_s   <= 0;
                    m7_s   <= 0;
                    m8_s   <= 0;
						  hlt<=1;
                    end
                5'b10000: begin //LD
                    aluc_e <= 1;
                    ar_e   <= 1;
                    br_e   <= 1;
                    dr_e   <= 1;
                    mdr_e  <= 1;
                    ir_e   <= 1;
                    reg_e  <= 1;
                    
                    // pc_e   <= 1;
                    mem_e  <= 1;
                    
                    jump   <= 0;
                    m2_s   <= 1; // d
                    m3_s   <= 0;
                    m4_s   <= 1;
                    m5_s   <= 0; // Ra
                    m6_s   <= 0;
                    m7_s   <= 0;
                    m8_s   <= 0;
                    end
                5'b10001: begin //ST
                    aluc_e <= 1;
                    ar_e   <= 1;
                    br_e   <= 1;
                    dr_e   <= 1;
                    mdr_e  <= 0;
                    ir_e   <= 1;
                    reg_e  <= 1;
                    
                    // pc_e   <= 1;
                    mem_e  <= 1;
                    
                    jump   <= 0;
                    m2_s   <= 1; // d
                    m3_s   <= 0;
                    m4_s   <= 0;
                    m5_s   <= 0;
                    m6_s   <= 1;
                    m7_s   <= 0;
                    m8_s   <= 0;
                    end
                5'b10010: begin //LI
                    aluc_e <= 0;
                    ar_e   <= 0;
                    br_e   <= 0;
                    dr_e   <= 0;
                    mdr_e  <= 0;
                    ir_e   <= 1;
                    reg_e  <= 1;
                    
                    // pc_e   <= 1;
                    mem_e  <= 1;
                    
                    jump   <= 0;
                    m2_s   <= 0;
                    m3_s   <= 0;
                    m4_s   <= 0;
                    m5_s   <= 1;
                    m6_s   <= 0;
                    m7_s   <= 0;
                    m8_s   <= 1;
                    end
                5'b10011, 5'b10100, 5'b10101, 5'b10110, 5'b10111: begin //B, BE,BLT, BLE, BNE
                    aluc_e <= 1;
                    ar_e   <= 1;
                    br_e   <= 1;
                    dr_e   <= 1;
                    mdr_e  <= 0;
                    ir_e   <= 1;
                    reg_e  <= 1;
                    
                    // pc_e   <= 1;
                    mem_e  <= 1;
                    
                    jump   <= 1;
                    m2_s   <= 1;
                    m3_s   <= 1;
                    m4_s   <= 0;
                    m5_s   <= 0;
                    m6_s   <= 0;
                    m7_s   <= 0;
                    m8_s   <= 0;
                    end
            default: begin 
					aluc_e <= 0;
					
					ar_e   <= 0;
					br_e   <= 0;
					dr_e   <= 0;
					mdr_e  <= 0;
					ir_e   <= 0;
					reg_e  <= 0;
					
            // pc_e   <= 0;
					mem_e  <= 0;
					
					jump   <= 0;
					m2_s   <= 0;
					m3_s   <= 0;
					m4_s   <= 0;
					m5_s   <= 0;
					m6_s   <= 0;
					m7_s   <= 0;
					m8_s   <= 0;
				end
				
        endcase
		  
		  if(phase==3'b101&(command==5'b00000||command==5'b00001||command==5'b00010||command==5'b00011||
		  command==5'b00100||command==5'b01000||command==5'b01001||command==5'b01010||command==5'b01011||command==5'b01100||
		  command==5'b10000||command==5'b10010))begin
				genr_w<=1;
		  end else begin
				genr_w<=0;
		  
		  end//phase 5notokinomi genr_w wo 1 nisuru
		  
		  if(phase==3'b101&command==5'b10001)begin
				mem_w<=1;
		  end else begin
				mem_w<=0;
		  end
		  
		  
        
    end
	 end



endmodule