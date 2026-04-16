module scrambler_downstream (
    input  wire        clk,
    input  wire        rst_n,
    input  wire        enable,
    input  wire [1:0]  data_in,  // 2-bit input (Even/Odd pair)
    output wire [1:0]  data_out  // 2-bit scrambled output
);

    reg [22:0] lfsr;
    wire s0, s1;

    // S0 is calculated from current state
    assign s0 = lfsr[22] ^ lfsr[17];

    // S1 is calculated by "looking ahead" to what the taps 
    // would be after 1 shift. 
    // Note: lfsr[21] becomes the new [22], lfsr[16] becomes the new [17]
    assign s1 = lfsr[21] ^ lfsr[16];

    // Parallel Scrambling
    assign data_out[0] = (enable) ? (data_in[0] ^ s0) : data_in[0];
    assign data_out[1] = (enable) ? (data_in[1] ^ s1) : data_in[1];

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            lfsr <= 23'h00001;
        end else if (enable) begin
            // Parallel shift by 2 positions
            // We push the two feedback bits into the bottom 2 bits
            lfsr <= {lfsr[20:0], s1, s0};
        end
    end
endmodule
