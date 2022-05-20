module register_general( //comment
    input clk,
    input rst,
    //　データを書き込む
    input   reg_write_en, // データをエントリーする信号
    input   [2:0] reg_write_dest,
    input   [15:0] reg_write_data,
    //　データを読み込む
    input   [2:0] reg_read_addr_1,
    output  [15:0] reg_read_data_1,
    //　データを読み込む
    input   [2:0] reg_read_addr_2,
    output  [15:0] reg_read_data_2

);

    reg     [15:0] reg_array [7:0]; // 8 registers

    always @ (posedge clk ) begin  
        
            if(reg_write_en==1'b1) begin  
                reg_array[reg_write_dest[2]*4+reg_write_dest[1]*2+reg_write_dest[0]] <= reg_write_data;  
            end
				if(rst==1'b1)begin
					reg_array[7]<=16'b0000000000000000;
					reg_array[6]<=16'b0000000000000000;
					reg_array[5]<=16'b0000000000000000;
					reg_array[4]<=16'b0000000000000000;
					reg_array[3]<=16'b0000000000000000;
					reg_array[2]<=16'b0000000000000000;
					reg_array[1]<=16'b0000000000000000;
					reg_array[0]<=16'b0000000000000000;
				end
        end
        
    
assign reg_read_data_1 = reg_array[reg_read_addr_1];  
assign reg_read_data_2 = reg_array[reg_read_addr_2];  
    
endmodule