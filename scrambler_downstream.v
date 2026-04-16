module scrambler_downstream (
    input  clk, rst,  enable,
    input [1:0]  data_in,  
    output [1:0]  data_out  
);

    reg [22:0] lfsr;
    wire s0, s1;

    assign s0 = lfsr[22] ^ lfsr[17];
    assign s1 = lfsr[2] ^ lfsr[5];

    // Parallel Scrambling
    assign data_out[0] = (enable) ? (data_in[0] ^ s0) : data_in[0];
    assign data_out[1] = (enable) ? (data_in[1] ^ s1) : data_in[1];

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            lfsr <= 23'h00001;
        end else if (enable) begin
            lfsr <= {lfsr[20:0], s1, s0};
        end
    end
endmodule
