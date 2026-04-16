module scrambler_upstream (
    input  clk, rst_n, enable, data_in,  
    output data_out 
);
    reg [22:0] lfsr;
    wire s0;

    assign s0 = lfsr[22] ^ lfsr[17]; 

    // Scramble: Input XOR S0
    assign data_out = (enable) ? (data_in ^ s0) : data_in;

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            lfsr <= 23'h00001; // Seed value from your doc
        end else if (enable) begin
            // Serial shift by 1 position
            lfsr <= {lfsr[21:0], s0};
        end
    end
endmodule
