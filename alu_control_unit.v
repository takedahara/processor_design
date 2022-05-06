module alu_control_unit(alu_control_unit_e, instruction_six, ALU_Cnt);
    input alu_control_unit_e;
    input [5:0] instruction_six; //命令最初の６ビット
    output reg [3:0] ALU_Cnt;
    
    always @(posedge alu_control_unit_e) begin
        casex (instruction_six)
            6'b00xxxx: ALU_Cnt=4'b0000; // load --> add
            6'b01xxxx: ALU_Cnt=4'b0000; // store --> add

            6'b10111x: ALU_Cnt=4'b0000; // 条件分岐命令 --> add

            // ALU演算・入出力命令: 11で始まるやつ
            6'b110000: ALU_Cnt=4'0000;
            6'b110001: ALU_Cnt=4'0001;
            6'b110010: ALU_Cnt=4'0010;
            6'b110011: ALU_Cnt=4'0011;
            6'b110100: ALU_Cnt=4'0100;
            6'b110101: ALU_Cnt=4'0001; // CMP --> SUB
            6'b110110: ALU_Cnt=4'0110;
            6'b110111: ALU_Cnt=4'0111;
            6'b111000: ALU_Cnt=4'1000; // Shift
            6'b111001: ALU_Cnt=4'1001;
            6'b111010: ALU_Cnt=4'1010;
            6'b111011: ALU_Cnt=4'1011;
            6'b111100: ALU_Cnt=4'1100;
            6'b111101: ALU_Cnt=4'1101;
            6'b111110: ALU_Cnt=4'1110;
            6'b111111: ALU_Cnt=4'1111;

            default: ALU_Cnt=4'b0000;
        endcase
    end

endmodule