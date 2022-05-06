module sign_extension(sign_e, d, result);
    input [7:0] d;
    output reg [15:0] result;
    
    always @( posedge sign_e ) begin
        result[15:0] <= { {8{d[7]}}, d };
    end

endmodule