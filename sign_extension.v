
module sign_extension(d, result);
    input [7:0] d;
    output  [15:0] result;
    

    
    assign result = { {8{d[7]}}, d };
    

endmodule