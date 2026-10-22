// Tiny Tapeout wrapper for the INT8 MAC.
// Every clock cycle the accumulator adds ui_in * uio_in (both signed INT8).
// uo_out shows the low 8 bits of the 32-bit accumulator.
// rst_n (active low) clears the accumulator to 0.
`default_nettype none

module tt_um_mac_int8 (
    input  wire [7:0] ui_in,    // operand a (INT8)
    output wire [7:0] uo_out,   // accumulator, low byte
    input  wire [7:0] uio_in,   // weight w (INT8)
    output wire [7:0] uio_out,  // unused
    output wire [7:0] uio_oe,   // unused (all inputs)
    input  wire       ena,      // always 1 when the design is selected
    input  wire       clk,
    input  wire       rst_n     // active-low reset
);

    reg  signed [31:0] acc;
    wire signed [31:0] acc_next;

    mac u_mac (
        .a       (ui_in),
        .w       (uio_in),
        .acc_in  (acc),
        .acc_out (acc_next)
    );

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n)
            acc <= 32'sd0;
        else if (ena)
            acc <= acc_next;
    end

    assign uo_out  = acc[7:0];
    assign uio_out = 8'b0;
    assign uio_oe  = 8'b0;

endmodule
