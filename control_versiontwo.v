module control_versiontwo(clk,rst,exec,
				S,Z,C,V,
				instruction,
				aluc_e,
				ar_e,br_e,dr_e,mdr_e,ir_e, // enablers
                reg_e, // signal for all non-general registers --> 同期
				genr_w,
				pc_e,
				mem_e, mem_w,
				m1_s,m2_s,m3_s,m4_s,m5_s, m6_s);
	input clk, rst, exec; // exec is 0 by default
	input S, Z, C, V;
	input [15:0] instruction;
	output reg	aluc_e,
				ar_e,br_e,dr_e,mdr_e,ir_e, 
                reg_e,
				genr_w, 
				pc_e,
				mem_e, mem_w, 
				m1_s,m2_s,m3_s,m4_s, m5_s, m6_s;
	output reg [5:0] alu_instruction; // ALU制御部へ ?? 書く

	reg executing = 0; // 実行中・停止中を表す
    reg stop_flag = 0; // if stop_flag == 1, then stop after this instruction

	reg [2:0] phase = 3'b000; // phaseを表す, initialised to 000
	reg [1:0] op;
	reg [2:0] r1;
	reg [2:0] r2;
	reg [3:0] alu_op;
	reg [3:0] d4;
	reg [7:0] d8;
	reg [4:0] command;

    op     <= instruction[15:14]; // op1
	// r1     <= instruction[13:11]; // register 1
	// r2     <= instruction[10:8]; // register 2
	// alu_op <= instruction[7:4]; // opcode (op3) of alu
	// d4     <= instruction[3:0]; // for shifter
	// d8     <= instruction[7:0]; // for load, store, condition

	always @(posedge clk or negedge rst) begin

        // set the value of alu_instruction depending on the type of instruction
        if(op==2'b11) alu_instruction <= { instruction[15:14], instruction[7:4] };
        else alu_instruction <= {instruction[15:10]};

        // set the value of "command" depending on the instruction
		if(op==2'b11) // ALU
			command <= {0,alu_op};
		else if(op==2'b00) //LD  r[Ra]=*(r[Rb]+sign_ext(d))
			command <= 5'b10000;
		else if(op==2'b01) //ST  *(r[Rb]+sign_ext(d))=r[Ra]
			command <= 5'b10001;
		else begin //op==2'b10
			if(r1==3'b000) //LI r[Rb]=sign_ext(d)
				command <= 5'b10010;
			else if(r1==3'b100) //B PC=PC+1+sign_ext(d)
				command <= 5'b10011;
			else if(r1==3'b111)begin
				if(r2==3'b000 & Z==1'b1) //BE PC=PC+1+sign_ext(d)
					command <= 5'b10100;
				else if(r2==3'b001 & S^V==1'b1) //BLT PC=PC+1+sign_ext(d)
					command <= 5'b10101;
				else if(r2==3'b010 & (Z||(S^V)==1)) //BLE PC=PC+1+sign_ext(d)
					command <= 5'b10110;
				else if(r2==3'b011 & (~Z==1'b1)) //BNE PC=PC+1+sing_ext(d)
					command <= 5'b10111;
			end
		end
    
        // reset
		if(~rst) phase <= 3'b000; // if rst==0, then 初期状態に戻す

        // exec
        if(executing & exec) begin // if executing and exec==1
            stop_flag <= 1; // stop after this instruction
        end
        
        case(phase) 
            3'b000:begin //初期状態
                if( (executing==0 & exec) || (executing & exec==0)) begin
                    phase <= 3'b001; //次のphaseに行く
                    executing <= 1;
                end else begin
                    phase <= 3'b000; //stay in 初期状態
                end
                aluc_e <= 0
                ar_e   <= 0
                br_e   <= 0
                dr_e   <= 0
                mdr_e  <= 0
                ir_e   <= 0
                reg_e  <= 0
                genr_w <= 0
                pc_e   <= 0
                mem_e  <= 0
                mem_w  <= 0
                m1_s   <= 0
                m2_s   <= 0
                m3_s   <= 0
                m4_s   <= 0
                m5_s   <= 0
                m6_s   <= 0
                end
            3'b001:begin // read RAM
                phase <=3'b010;
                aluc_e <= 0
                ar_e   <= 0
                br_e   <= 0
                dr_e   <= 0
                mdr_e  <= 0
                ir_e   <= 0
                reg_e  <= 0
                genr_w <= 0
                pc_e   <= 0
                mem_e  <= 1
                mem_w  <= 0
                m1_s   <= 0
                m2_s   <= 0
                m3_s   <= 0
                m4_s   <= 0
                m5_s   <= 0
                m6_s   <= 0
                end
            3'b010:begin //P1 命令フェッチ
                phase <= 3'b011;
                // decode<=18'b000001011000000001; // ?? why mem_w = 1?
                aluc_e <= 0
                ar_e   <= 0
                br_e   <= 0
                dr_e   <= 0
                mdr_e  <= 0
                ir_e   <= 0
                reg_e  <= 1
                genr_w <= 0
                pc_e   <= 1
                mem_e  <= 1
                mem_w  <= 0
                m1_s   <= 0
                m2_s   <= 0
                m3_s   <= 0
                m4_s   <= 0
                m5_s   <= 0
                m6_s   <= 0
                end
            3'b011:begin //P2　命令デコード、レジスタ読み出し
                phase <= 3'b100;
                case(command) //Depending on the instruction/command
                    5'b00000, 5'b00001, 5'b00010, 5'b00011, 5'b00100, 5'b00101, 5'b00110:begin
                        //ADD, SUB, AND, OR, XOR, CMP, MOV
                        aluc_e <= 0
                        ar_e   <= 0 // write into ar, br
                        br_e   <= 0
                        dr_e   <= 0
                        mdr_e  <= 0
                        ir_e   <= 1
                        reg_e  <= 1
                        genr_w <= 0
                        pc_e   <= 0
                        mem_e  <= 0
                        mem_w  <= 0
                        m1_s   <= 0
                        m2_s   <= 0
                        m3_s   <= 0
                        m4_s   <= 0
                        m5_s   <= 0
                        m6_s   <= 0
                        end
                    5'b01000, 5'b01001, 5'b01010, 5'b01011:begin //SLL, SLR, SRL, SRA
                        aluc_e <= 0
                        ar_e   <= 0 // write into ar, br
                        br_e   <= 0
                        dr_e   <= 0
                        mdr_e  <= 0
                        ir_e   <= 1
                        reg_e  <= 1
                        genr_w <= 0
                        pc_e   <= 0
                        mem_e  <= 0
                        mem_w  <= 0
                        m1_s   <= 0
                        m2_s   <= 1 // d
                        m3_s   <= 0
                        m4_s   <= 0
                        m5_s   <= 0
                        m6_s   <= 0
                        end
                    5'b01100:begin //IN doesn't do anything
                        aluc_e <= 0
                        ar_e   <= 0
                        br_e   <= 0
                        dr_e   <= 0
                        mdr_e  <= 0
                        ir_e   <= 0
                        reg_e  <= 0
                        genr_w <= 0
                        pc_e   <= 0
                        mem_e  <= 0
                        mem_w  <= 0
                        m1_s   <= 0
                        m2_s   <= 0
                        m3_s   <= 0
                        m4_s   <= 0
                        m5_s   <= 0
                        m6_s   <= 0
                        end
                    5'b01101:begin //OUT
                        aluc_e <= 0
                        ar_e   <= 0
                        br_e   <= 0
                        dr_e   <= 0
                        mdr_e  <= 0
                        ir_e   <= 0
                        reg_e  <= 1 // put Ra into AR
                        genr_w <= 0
                        pc_e   <= 0
                        mem_e  <= 0
                        mem_w  <= 0
                        m1_s   <= 0
                        m2_s   <= 0 // read Ra into AR
                        m3_s   <= 0
                        m4_s   <= 0
                        m5_s   <= 0
                        m6_s   <= 0
                        end
                    5'b01111:begin //HLT
                        stop_flag <= 1
                        aluc_e <= 0 // とりあえず set everything else to 0
                        ar_e   <= 1
                        br_e   <= 1
                        dr_e   <= 0
                        mdr_e  <= 0
                        ir_e   <= 0
                        reg_e  <= 0
                        genr_w <= 0
                        pc_e   <= 0
                        mem_e  <= 0
                        mem_w  <= 0
                        m1_s   <= 0
                        m2_s   <= 0
                        m3_s   <= 0
                        m4_s   <= 0
                        m5_s   <= 0
                        m6_s   <= 0
                        end
                    5'b10000, 5'b10001:begin //LD, ST
                        aluc_e <= 0
                        ar_e   <= 0
                        br_e   <= 0
                        dr_e   <= 0
                        mdr_e  <= 0
                        ir_e   <= 1 // read d from IR into AR, read Rb into BR
                        reg_e  <= 1
                        genr_w <= 0
                        pc_e   <= 0
                        mem_e  <= 0
                        mem_w  <= 0
                        m1_s   <= 0
                        m2_s   <= 0
                        m3_s   <= 0
                        m4_s   <= 0
                        m5_s   <= 0
                        m6_s   <= 0
                        end
                    5'b10010:begin //LI r[Rb]=sign_ext(d)
                        aluc_e <= 0
                        ar_e   <= 0
                        br_e   <= 0
                        dr_e   <= 0
                        mdr_e  <= 0
                        ir_e   <= 1 // read d from ir into AR
                        reg_e  <= 1
                        genr_w <= 0
                        pc_e   <= 0
                        mem_e  <= 0
                        mem_w  <= 0
                        m1_s   <= 0
                        m2_s   <= 1 // d
                        m3_s   <= 0
                        m4_s   <= 0
                        m5_s   <= 0
                        m6_s   <= 0
                        end
                    5'b10011, 5'b10100, 5'b10101, 5'b10110, 5'b10111:begin //B, BE, BLT, BLE, BNE PC=PC+1+sign_ext(d) 
                        aluc_e <= 0
                        ar_e   <= 0
                        br_e   <= 0
                        dr_e   <= 0
                        mdr_e  <= 0
                        ir_e   <= 1 // read d from ir
                        reg_e  <= 1
                        genr_w <= 0
                        pc_e   <= 1 // PC+1
                        mem_e  <= 0
                        mem_w  <= 0
                        m1_s   <= 0
                        m2_s   <= 1 // d
                        m3_s   <= 1 // read PC+1
                        m4_s   <= 0
                        m5_s   <= 0
                        m6_s   <= 0
                        end
                    default: begin end // defaultは何もしない
                endcase
                end
            3'b100:begin //P3　演算
                phase <= 3'b101;
                case(command)
                    5'b00000, 5'b00001, 5'b00010, 5'b00011, 5'b00100, 5'b00101:begin
                        //ADD, SUB, AND, OR, XOR, CMP
                        aluc_e <= 1
                        ar_e   <= 1 // 読み出す
                        br_e   <= 1
                        dr_e   <= 0 // result goes into DR
                        mdr_e  <= 0
                        ir_e   <= 0
                        reg_e  <= 1
                        genr_w <= 0
                        pc_e   <= 0
                        mem_e  <= 0
                        mem_w  <= 0
                        m1_s   <= 0
                        m2_s   <= 0
                        m3_s   <= 0
                        m4_s   <= 0
                        m5_s   <= 0
                        m6_s   <= 0
                        end
                    5'b00110:begin //MOV
                        aluc_e <= 1
                        ar_e   <= 1 // Raを読み出す
                        br_e   <= 0 // いらない
                        dr_e   <= 0 // result goes into DR
                        mdr_e  <= 0
                        ir_e   <= 0
                        reg_e  <= 1
                        genr_w <= 0
                        pc_e   <= 0
                        mem_e  <= 0
                        mem_w  <= 0
                        m1_s   <= 0
                        m2_s   <= 0
                        m3_s   <= 0
                        m4_s   <= 0
                        m5_s   <= 0
                        m6_s   <= 0
                        end
                    5'b01000, 5'b01001, 5'b01010, 5'b01011:begin //SLL, SLR, SRL, SRA
                        aluc_e <= 1
                        ar_e   <= 1 // dを読み出す
                        br_e   <= 1 // Rbを読み出す
                        dr_e   <= 0 // Result of ALU goes into DR
                        mdr_e  <= 0
                        ir_e   <= 0
                        reg_e  <= 1
                        genr_w <= 0
                        pc_e   <= 0
                        mem_e  <= 0
                        mem_w  <= 0
                        m1_s   <= 0
                        m2_s   <= 0
                        m3_s   <= 0
                        m4_s   <= 0
                        m5_s   <= 0
                        m6_s   <= 0
                        end
                    5'b01100:begin //IN doesn't do anything in Phase 3
                        aluc_e <= 0
                        ar_e   <= 0
                        br_e   <= 0
                        dr_e   <= 0
                        mdr_e  <= 0
                        ir_e   <= 0
                        reg_e  <= 0
                        genr_w <= 0
                        pc_e   <= 0
                        mem_e  <= 0
                        mem_w  <= 0
                        m1_s   <= 0
                        m2_s   <= 0
                        m3_s   <= 0
                        m4_s   <= 0
                        m5_s   <= 0
                        m6_s   <= 0
                        end
                    5'b01101:begin //OUT also doesn't do anything in Phase 3
                        aluc_e <= 0
                        ar_e   <= 0
                        br_e   <= 0
                        dr_e   <= 0
                        mdr_e  <= 0
                        ir_e   <= 0
                        reg_e  <= 0
                        genr_w <= 0
                        pc_e   <= 0
                        mem_e  <= 0
                        mem_w  <= 0
                        m1_s   <= 0
                        m2_s   <= 0
                        m3_s   <= 0
                        m4_s   <= 0
                        m5_s   <= 0
                        m6_s   <= 0
                        end
                    5'b01111:begin //HLT
                        stop_flag <= 1
                        aluc_e <= 0 // とりあえず set everything else to 0
                        ar_e   <= 1
                        br_e   <= 1
                        dr_e   <= 0
                        mdr_e  <= 0
                        ir_e   <= 0
                        reg_e  <= 0
                        genr_w <= 0
                        pc_e   <= 0
                        mem_e  <= 0
                        mem_w  <= 0
                        m1_s   <= 0
                        m2_s   <= 0
                        m3_s   <= 0
                        m4_s   <= 0
                        m5_s   <= 0
                        m6_s   <= 0
                        end
                    5'b10000:begin //LD  r[Ra]=*(r[Rb]+sign_ext(d))
                        aluc_e <= 1
                        ar_e   <= 0
                        br_e   <= 1
                        dr_e   <= 0
                        mdr_e  <= 0
                        ir_e   <= 0
                        reg_e  <= 1
                        genr_w <= 0
                        pc_e   <= 0
                        mem_e  <= 0
                        mem_w  <= 0
                        m1_s   <= 0
                        m2_s   <= 1 // outputs d to ALU
                        m3_s   <= 0 // outputs Rb to ALU
                        m4_s   <= 0
                        m5_s   <= 0
                        m6_s   <= 0
                        end
                    5'b10001:begin //ST  *(r[Rb]+sign_ext(d))=r[Ra]
                        aluc_e <= 1 // calculates Rb + d
                        ar_e   <= 1
                        br_e   <= 1 // storing Rb
                        dr_e   <= 0
                        mdr_e  <= 0
                        ir_e   <= 0
                        reg_e  <= 1
                        genr_w <= 0
                        pc_e   <= 0
                        mem_e  <= 0
                        mem_w  <= 0
                        m1_s   <= 0
                        m2_s   <= 1 // outputs d to ALU
                        m3_s   <= 0 // outputs Rb to ALU
                        m4_s   <= 0
                        m5_s   <= 0
                        m6_s   <= 0
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
                    default: begin end
                endcase
                end
            3'b101:begin //P4　主記憶アクセス・IN, OUT
                phase <= 3'b110;
                case(command)
                    5'b00000, 5'b00001, 5'b00010, 5'b00011, 5'b00100, 5'b00101, 
                    5'b00110, 5'b01000, 5'b01001, 5'b01010, 5'b01011:begin
                        //ADD, SUB, AND, OR, XOR, CMP, MOV, SLL, SLR, SRL, SRA
                        // Doesn't do anything in Phase 4
                        aluc_e <= 0
                        ar_e   <= 0
                        br_e   <= 0
                        dr_e   <= 0
                        mdr_e  <= 0
                        ir_e   <= 0
                        reg_e  <= 0
                        genr_w <= 0
                        pc_e   <= 0
                        mem_e  <= 0
                        mem_w  <= 0
                        m1_s   <= 0
                        m2_s   <= 0
                        m3_s   <= 0
                        m4_s   <= 0
                        m5_s   <= 0
                        m6_s   <= 0
                        end
                    5'b01100:begin //IN
                        aluc_e <= 0
                        ar_e   <= 0
                        br_e   <= 0
                        dr_e   <= 0
                        mdr_e  <= 0 // Direct kakikomi from 外部入力
                        ir_e   <= 0
                        reg_e  <= 1
                        genr_w <= 0
                        pc_e   <= 0
                        mem_e  <= 0
                        mem_w  <= 0
                        m1_s   <= 0
                        m2_s   <= 0
                        m3_s   <= 0
                        m4_s   <= 0
                        m5_s   <= 0
                        m6_s   <= 0
                        end
                    5'b01101:begin //OUT
                        aluc_e <= 0
                        ar_e   <= 1 // read Ra --> 直接に外部出力へ
                        br_e   <= 0
                        dr_e   <= 0
                        mdr_e  <= 0
                        ir_e   <= 0
                        reg_e  <= 1
                        genr_w <= 0
                        pc_e   <= 0
                        mem_e  <= 0
                        mem_w  <= 0
                        m1_s   <= 0
                        m2_s   <= 0
                        m3_s   <= 0
                        m4_s   <= 0
                        m5_s   <= 0
                        m6_s   <= 0
                        end
                    5'b01111:begin //HLT
                        stop_flag <= 1
                        aluc_e <= 0 // とりあえず set everything else to 0
                        ar_e   <= 1
                        br_e   <= 1
                        dr_e   <= 0
                        mdr_e  <= 0
                        ir_e   <= 0
                        reg_e  <= 0
                        genr_w <= 0
                        pc_e   <= 0
                        mem_e  <= 0
                        mem_w  <= 0
                        m1_s   <= 0
                        m2_s   <= 0
                        m3_s   <= 0
                        m4_s   <= 0
                        m5_s   <= 0
                        m6_s   <= 0
                        end
                    5'b10000:begin //LD  r[Ra]=*(r[Rb]+sign_ext(d))
                        aluc_e <= 0
                        ar_e   <= 0
                        br_e   <= 0
                        dr_e   <= 1
                        mdr_e  <= 1
                        ir_e   <= 1
                        reg_e  <= 1
                        genr_w <= 0
                        pc_e   <= 0
                        mem_e  <= 1
                        mem_w  <= 0
                        m1_s   <= 0
                        m2_s   <= 0
                        m3_s   <= 0
                        m4_s   <= 0
                        m5_s   <= 0
                        m6_s   <= 1 // DRをアドレスとして主記憶アクセス ?? slides isn't the same
                        end
                    5'b10001:begin //ST  *(r[Rb]+sign_ext(d))=r[Ra]
                        aluc_e <= 0
                        ar_e   <= 0
                        br_e   <= 0
                        dr_e   <= 1
                        mdr_e  <= 1
                        ir_e   <= 1
                        reg_e  <= 1
                        genr_w <= 0
                        pc_e   <= 0
                        mem_e  <= 1
                        mem_w  <= 0
                        m1_s   <= 0
                        m2_s   <= 0
                        m3_s   <= 0
                        m4_s   <= 0
                        m5_s   <= 0
                        m6_s   <= 1 // DRをアドレスとして主記憶アクセス ?? slides isn't the same
                        end
                    5'b10010, 5'b10011, 5'b10100, 5'b10101, 5'b10110, 5'b10111:begin
                        //LI, B, BE, BLT, BLE, BNE PC=PC+1+sign_ext(d)
                        // Doesn't do anything in Phase 4
                        aluc_e <= 0
                        ar_e   <= 0
                        br_e   <= 0
                        dr_e   <= 0
                        mdr_e  <= 0
                        ir_e   <= 0
                        reg_e  <= 0
                        genr_w <= 0
                        pc_e   <= 0
                        mem_e  <= 0
                        mem_w  <= 0
                        m1_s   <= 0
                        m2_s   <= 0
                        m3_s   <= 0
                        m4_s   <= 0
                        m5_s   <= 0
                        m6_s   <= 0
                        end
                    default: begin end
                endcase
                end
            3'b110:begin //P5　レジスタ書き込み　PC更新
                phase <= 3'b000;
                case(command)
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
                    5'b01111:begin //HLT
                        stop_flag <= 1
                        aluc_e <= 0 // とりあえず set everything else to 0
                        ar_e   <= 1
                        br_e   <= 1
                        dr_e   <= 0
                        mdr_e  <= 0
                        ir_e   <= 0
                        reg_e  <= 0
                        genr_w <= 0
                        pc_e   <= 0
                        mem_e  <= 0
                        mem_w  <= 0
                        m1_s   <= 0
                        m2_s   <= 0
                        m3_s   <= 0
                        m4_s   <= 0
                        m5_s   <= 0
                        m6_s   <= 0
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
                    default: begin end
                endcase
                if(stop_flag) begin
                    executing <= 0;
                end
            end
        endcase
	end
endmodule
				
				