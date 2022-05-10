module control_combination(rst,exec,
                phase //top levelお願い
				S,Z,C,V,
				instruction,
				aluc_e,
				ar_e,br_e,dr_e,mdr_e,ir_e, // enablers
                reg_e, // signal for all non-general registers --> 同期
				genr_w,
				//pc_e,
				mem_e, mem_w,
				m1_s,m2_s,m3_s,m4_s,m5_s, m6_s, m7_s,
                alu_instruction,
                stop_flag);//top levelお願い
	input rst, exec; // exec is 0 by default
    input [2:0] phase; // a number from 0 to 5
	input S, Z, C, V;
	input [15:0] instruction;
	output reg	aluc_e,
				ar_e,br_e,dr_e,mdr_e,ir_e, 
                reg_e,
				genr_w, 
				//pc_e,
				mem_e, mem_w, 
				m1_s,m2_s,m3_s,m4_s, m5_s, m6_s, m7_s;
	output [5:0] alu_instruction; // ALU制御部へ
    output reg  stop flag; // if stop_flag == 1, then stop after this instruction

    reg executing = 0; // 実行中・停止中を表す

    // set the value of "command" depending on the instruction
    case(op)
        2'b11: command <= {0,alu_op}; // ALU
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

    // initialisation
        aluc_e <= 0;
        ar_e   <= 0;
        br_e   <= 0;
        dr_e   <= 0;
        mdr_e  <= 0;
        ir_e   <= 0;
        reg_e  <= 0;
        genr_w <= 0;
        // pc_e   <= 0;
        mem_e  <= 0;
        mem_w  <= 0;
        m1_s   <= 0;
        m2_s   <= 0;
        m3_s   <= 0;
        m4_s   <= 0;
        m5_s   <= 0;
        m6_s   <= 0;
        m7_s   <= 0;

        if (rst) begin
            aluc_e <= 0;
            ar_e   <= 0;
            br_e   <= 0;
            dr_e   <= 0;
            mdr_e  <= 0;
            ir_e   <= 0;
            reg_e  <= 0;
            genr_w <= 0;
            // pc_e   <= 0;
            mem_e  <= 0;
            mem_w  <= 0;
            m1_s   <= 0;
            m2_s   <= 0;
            m3_s   <= 0;
            m4_s   <= 0;
            m5_s   <= 0;
            m6_s   <= 0;
            m7_s   <= 0;
        end


    case(command)
        5'b00000, 5'b00001, 5'b00010, 5'b00011, 5'b00100: begin//ADD, SUB, AND, OR, XOR
            aluc_e <= 1;
            ar_e   <= 1;
            br_e   <= 1;
            dr_e   <= 1;
            mdr_e  <= 0;
            ir_e   <= 1;
            reg_e  <= 1;
            genr_w <= 1;
            // pc_e   <= 1;
            mem_e  <= 1;
            mem_w  <= 0;
            m1_s   <= 1; // PC+1
            m2_s   <= 0;
            m3_s   <= 0;
            m4_s   <= 0;
            m5_s   <= 0;
            m6_s   <= 0;
            m7_s   <= 0;
            end
        5'b00101: begin//CMP
            end
        5'b00110: begin //MOV
            aluc_e <= 1;
            ar_e   <= 0;
            br_e   <= 0;
            dr_e   <= 0;
            mdr_e  <= 0;
            ir_e   <= 0;
            reg_e  <= 0;
            genr_w <= 0;
            // pc_e   <= 0;
            mem_e  <= 0;
            mem_w  <= 0;
            m1_s   <= 0;
            m2_s   <= 0;
            m3_s   <= 0;
            m4_s   <= 0;
            m5_s   <= 0;
            m6_s   <= 0;
            m7_s   <= 0;
            end
        5'b01000, 5'b01001, 5'b01010, 5'b01011: begin //SLL, SLR, SRL, SRA
            aluc_e <= 1;
            ar_e   <= 0;
            br_e   <= 1;
            dr_e   <= 1;
            mdr_e  <= 0;
            ir_e   <= 0;
            reg_e  <= 1;
            genr_w <= 1;
            // pc_e   <= 1;
            mem_e  <= 1;
            mem_w  <= 0;
            m1_s   <= 0;
            m2_s   <= 1; // d
            m3_s   <= 0;
            m4_s   <= 0;
            m5_s   <= 0;
            m6_s   <= 0;
            m7_s   <= 0;
            end
        5'b01100: begin //IN
            aluc_e <= 0;
            ar_e   <= 0;
            br_e   <= 0;
            dr_e   <= 0;
            mdr_e  <= 1;
            ir_e   <= 1;
            reg_e  <= 1;
            genr_w <= 1;
            // pc_e   <= 1;
            mem_e  <= 1;
            mem_w  <= 0;
            m1_s   <= 0;
            m2_s   <= 0;
            m3_s   <= 0;
            m4_s   <= 1;
            m5_s   <= 1;
            m6_s   <= 0;
            m7_s   <= 1;
            end
        5'b01101: begin //OUT
            aluc_e <= 0;
            ar_e   <= 1;
            br_e   <= 0;
            dr_e   <= 0;
            mdr_e  <= 0;
            ir_e   <= 1;
            reg_e  <= 1;
            genr_w <= 0;
            // pc_e   <= 1;
            mem_e  <= 1;
            mem_w  <= 0;
            m1_s   <= 0;
            m2_s   <= 0;
            m3_s   <= 0;
            m4_s   <= 0;
            m5_s   <= 0;
            m6_s   <= 0;
            m7_s   <= 0;
            end
        5'b01111: begin //HLT
            aluc_e <= 0;
            ar_e   <= 0;
            br_e   <= 0;
            dr_e   <= 0;
            mdr_e  <= 0;
            ir_e   <= 0;
            reg_e  <= 0;
            genr_w <= 0;
            // pc_e   <= 0;
            mem_e  <= 0;
            mem_w  <= 0;
            m1_s   <= 0;
            m2_s   <= 0;
            m3_s   <= 0;
            m4_s   <= 0;
            m5_s   <= 0;
            m6_s   <= 0;
            m7_s   <= 0;
            end
        5'b10000: begin //LD
            aluc_e <= 1;
            ar_e   <= 0;
            br_e   <= 1;
            dr_e   <= 1;
            mdr_e  <= 0;
            ir_e   <= 1;
            reg_e  <= 1;
            genr_w <= 1;
            // pc_e   <= 1;
            mem_e  <= 1;
            mem_w  <= 0;
            m1_s   <= 0;
            m2_s   <= 1; // d
            m3_s   <= 0;
            m4_s   <= 0;
            m5_s   <= 0; // Ra
            m6_s   <= 0;
            m7_s   <= 0;
            end
        5'b10001: begin //ST
            aluc_e <= 1;
            ar_e   <= 1;
            br_e   <= 1;
            dr_e   <= 1;
            mdr_e  <= 0;
            ir_e   <= 0;
            reg_e  <= 1;
            genr_w <= 0;
            // pc_e   <= 1;
            mem_e  <= 1;
            mem_w  <= 1;
            m1_s   <= 0;
            m2_s   <= 1; // d
            m3_s   <= 0;
            m4_s   <= 0;
            m5_s   <= 0;
            m6_s   <= 1;
            m7_s   <= 0;
            end
        5'b10010: begin //LI ???
            aluc_e <= 0;
            ar_e   <= 0;
            br_e   <= 0;
            dr_e   <= 0;
            mdr_e  <= 0;
            ir_e   <= 1;
            reg_e  <= 1;
            genr_w <= 0;
            // pc_e   <= 1;
            mem_e  <= 1;
            mem_w  <= 0;
            m1_s   <= 0;
            m2_s   <= 0;
            m3_s   <= 0;
            m4_s   <= 0;
            m5_s   <= 1;
            m6_s   <= 0;
            m7_s   <= 0;
            end
        5'b10011, 5'b10100, 5'b10101, 5'b10110, 5'b10111: begin //B, BE,BLT, BLE, BNE
            aluc_e <= 1;
            ar_e   <= 0;
            br_e   <= 0;
            dr_e   <= 1;
            mdr_e  <= 0;
            ir_e   <= 1;
            reg_e  <= 1;
            genr_w <= 0;
            // pc_e   <= 1;
            mem_e  <= 1;
            mem_w  <= 0;
            m1_s   <= 0;
            m2_s   <= 1;
            m3_s   <= 1;
            m4_s   <= 0;
            m5_s   <= 0;
            m6_s   <= 0;
            m7_s   <= 0;
            end
        default: begin end
    endcase

    if(phase==3'b000) begin
        if( (executing==0 & exec) || (executing & exec==0)) begin
                    phase <= 3'b001; //次のphaseに行く
                    executing <= 1;
                end else begin
                    phase <= 3'b000; //stay in 初期状態
                end
    end else if() begin
    end



endmodule