module gf_mult_2_4 (
    input [3:0] a,       // Data byte (e.g., from message)
    input [3:0]b,       // Coefficient (e.g., from the Generator)
    output wire [3:0] q        // The GF Product
);

    // Partial products for each bit of 'b'
    wire [3:0] p0, p1, p2, p3;

    // Bit 0: No shift
    assign p0 = b[0] ? a : 4'd0;

    // Bit 1: Shift 'a' once and reduce if it overflows (MSB was 1)
    // The reduction value 4'b0011 comes from x^4 + x + 1 (dropping the x^4)
    wire [3:0] a_x1 = {a[2:0], 1'b0} ^ (a[3] ? 4'b0011 : 4'b0000);
    assign p1 = b[1] ? a_x1 : 4'd0;

    // Bit 2: Shift again and reduce
    wire [3:0] a_x2 = {a_x1[2:0], 1'b0} ^ (a_x1[3] ? 4'b0011 : 4'b0000);
    assign p2 = b[2] ? a_x2 : 4'd0;

    // Bit 3: Shift again and reduce
    wire [3:0] a_x3 = {a_x2[2:0], 1'b0} ^ (a_x2[3] ? 4'b0011 : 4'b0000);
    assign p3 = b[3] ? a_x3 : 4'd0;

    // The final result is the XOR sum (addition) of all partial products
    assign q = p0 ^ p1 ^ p2 ^ p3;

endmodule
