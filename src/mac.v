// INT8 multiply-accumulate unit.
// acc_out = acc_in + (a * w), all signed.
// Written to the same spec as the MAC in the NN-accelerator project.
`default_nettype none

module mac (
    input  wire signed [7:0]  a,       // operand (activation), INT8
    input  wire signed [7:0]  w,       // weight, INT8
    input  wire signed [31:0] acc_in,  // running accumulator
    output wire signed [31:0] acc_out  // acc_in + a*w
);
    assign acc_out = acc_in + a * w;
endmodule
