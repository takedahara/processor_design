

module control(phase,
				S,Z,C,V,
				instruction,
				aluc_e,
				ar_e,br_e,dr_e,mdr_e,ir_e, // enablers
                reg_e, // signal for all non-general registers --> 同期
				genr_w,
				//pc_e,
				mem_e, mem_w,
				jump,m2_s,m3_s,m4_s,m5_s, m6_s, m7_s, m8_s,m9_s,out_s,hlt,szcv_s,
                alu_instruction);
   input [2:0] phase;
	input S, Z, C, V;
	input [15:0] instruction;
	output reg	aluc_e,
				ar_e,br_e,dr_e,mdr_e,ir_e, 
                reg_e,
				genr_w, 
				mem_e, mem_w, 
				jump,m2_s,m3_s,m4_s, m5_s, m6_s, m7_s, m8_s,m9_s,out_s,szcv_s;
    output reg hlt;
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
                            3'b000: begin
											case(Z)
												1'b1:command<=5'b10100; //BE PC=PC+1+sign_ext(d)
												1'b0:command<=5'b11000;  //11000 wo 10100
												default:command<=5'b11000;
											endcase
									 end
									 3'b001: begin
											case(S^V)
												1'b1:command<=5'b10101;  //BLT PC=PC+1+sign_ext(d)
												1'b0:command<=5'b11000;  //11000 wo 10101
												default:command<=5'b11000;
											endcase
									 end
									 3'b010: begin
											case(Z||(S^V))
												1'b1:command<=5'b10110;  //BLE PC=PC+1+sign_ext(d)
												1'b0:command<=5'b11000;  //11000 wo 10110
												default:command<=5'b11000;
											endcase
									 end
									 3'b011: begin
											case(Z)
												1'b1:command<=5'b11000;   //11000 wo 10111
												1'b0:command<=5'b10111;  //BNE PC=PC+1+sing_ext(d)
												default:command<=5'b11000;
											endcase
									 end
									 default:command<=5'b11000;
                        endcase
						  end
						  default:command<=5'b11000;
                    
                endcase
            end
				default:command<=5'b11000;
        endcase
 

        // alu control unit signal
        if(phase==3'b000 || command==5'b01100 || command==5'b01101 || command==5'b01111
        || command== 5'b10010) begin
            aluc_e <= 0;
        end else begin
            aluc_e <= 1;
        end

        // ar signal
        if(command== 5'b00000 || command==5'b00001 || command==5'b00010 || command==5'b00011
        || command==5'b00100 || command==5'b00101 || command==5'b01101 || command==5'b10000
        || command==5'b10001 || command==5'b10011 || command==5'b10100 || command==5'b10101
        || command==5'b10110 || command==5'b10111||command==5'b00110) begin
            ar_e <= 1;
        end else begin
            ar_e <= 0;
        end
        
        // br signal
        if(phase==3'b000 || command==5'b01100 || command==5'b01101 || command==5'b01111
        || command==5'b10010) begin
            br_e <= 0;
        end else begin
            br_e <= 1;
        end

        // dr signal
        if(phase==3'b000 || command==5'b00101 ||  command==5'b01100 || command==5'b01101
        || command==5'b01111 || command==5'b10010) begin
            dr_e <= 0;
        end else begin
            dr_e <= 1;
        end

        // mdr signal
        if(command==5'b01100 || command==5'b10000) begin
            mdr_e <= 1;
        end else begin
            mdr_e <= 0;
        end

        // ir signal
        if(phase==3'b000 || command==5'b01111) begin
            ir_e <= 0;
        end else begin
            ir_e <= 1;
        end

        // the clock for all the registers
        if(phase==3'b000 || command==5'b01111) begin
            reg_e <= 0;
        end else begin
            reg_e <= 1;
        end

        // memory read
        if(phase==3'b000 || command==5'b00101 || command==5'b00110 || command==5'b01111) begin
            mem_e <= 0;
        end else begin
            mem_e <= 1;
        end

        // jump signal
        if(command==5'b10011 || command==5'b10100 || command==5'b10101 || command==5'b10110 || 
        command==5'b10111)begin
            jump <= 1;
        end else begin
            jump <= 0;
        end

        // mux2 selector
        if(command==5'b01000 || command==5'b01001 || command==5'b01010 || command==5'b01011
        || command==5'b10000 || command==5'b10001 || command==5'b10011 || command==5'b10100
        || command==5'b10101 || command==5'b10110 || command==5'b10111) begin
            m2_s <= 1;
        end else begin
            m2_s <= 0;
        end
        
        // mux3 selector
        if(command==5'b10011 || command==5'b10100 || command==5'b10101 || command==5'b10110
        || command==5'b10111) begin
            m3_s <= 1;
        end else begin
            m3_s <= 0;
        end
        
        // mux4 selector
        if(command==5'b01100 || command==5'b10000) begin
            m4_s <= 1;
        end else begin
            m4_s <= 0;
        end

        // mux5 selector
        if(phase==3'b000 || command==5'b00101 || command==5'b01101 || command==5'b01111
        || command==5'b10000 || command==5'b10001 || command==5'b10011 || command==5'b10100
        || command==5'b10101 || command==5'b10110 || command==5'b10111) begin
            m5_s <= 0;
        end else begin
            m5_s <= 1;
        end
        
        // mux6 selector
        if(command==5'b10001) begin
            m6_s <= 1;
        end else begin
            m6_s <= 0;
        end

        // mux7 selector
        if(command==5'b01100) begin
            m7_s <= 1;
        end else begin
            m7_s <= 0;
        end

        // mux8 selector
        if(command==5'b10010) begin
            m8_s <= 1;
        end else begin
            m8_s <= 0;
        end
		  
		  // mux9 selector
		  if((instruction[3]==1'b1)&&(command==5'b00000||command==5'b00001||command==5'b00010||
		  command==5'b00011||command==5'b00100||command==5'b00101||command==5'b00110))begin
				m9_s<=1;
		  end else begin
				m9_s<=0;
		  end

        // output signal (for 7SEG LED)
        if(command==5'b01101) begin // OUT命令
            out_s <= 1;
        end else begin
            out_s <= 0;
        end

        // halt flag
        if(command==5'b01111) begin //HALT命令
            hlt <= 1;
        end else begin
            hlt <= 0;
        end

        // 汎用レジスタに書き込む
		if(phase==3'b101 && (command==5'b00000 || command==5'b00001 || command==5'b00010
        || command==5'b00011 || command==5'b00100 || command==5'b01000 || command==5'b01001
        || command==5'b01010 || command==5'b01011 || command==5'b01100 || command==5'b10000
        || command==5'b10010||command==5'b00110))begin
			genr_w<=1;
		end else begin
			genr_w<=0;
		end
		
        // メモリに書き込む
		if(phase==3'b101 && command==5'b10001)begin
			mem_w<=1;
		end else begin
			mem_w<=0;
		end
		
		if(phase==3'b101&&(command==5'b00000 || command==5'b00001 || command==5'b00010
        || command==5'b00011 || command==5'b00100 || command==5'b00101 || command==5'b00110
        || command==5'b01000 || command==5'b01001 || command==5'b01010 || command==5'b01011
        ))begin
			szcv_s<=1'b1;
		end else begin
			szcv_s<=1'b0;
		end
    end // alwaysのend

endmodule