`default_nettype none

module tt_um_traffic (
    input  wire [7:0] ui_in,    // Dedicated inputs
    output wire [7:0] uo_out,   // Dedicated outputs
    input  wire [7:0] uio_in,   // IOs: Input path
    output wire [7:0] uio_out,  // IOs: Output path
    output wire [7:0] uio_oe,   // IOs: Enable path
    input  wire       ena,      // always 1 when powered
    input  wire       clk,      // clock
    input  wire       rst_n     // active low reset
);

    wire slow_clk;
    wire red, yellow, green;

    // Clock divider submodule
    clock_divider u_divider (
        .clk      (clk),
        .rst_n    (rst_n),
        .slow_clk (slow_clk)
    );

    // Traffic light controller submodule
    traffic_light_fsm u_fsm (
        .clk    (slow_clk),
        .rst_n  (rst_n),
        .red    (red),
        .yellow (yellow),
        .green  (green)
    );

    // Output mapping
    assign uo_out[0] = red;
    assign uo_out[1] = yellow;
    assign uo_out[2] = green;
    assign uo_out[7:3] = 5'b00000;

    // No bidirectional pins used
    assign uio_out = 8'b00000000;
    assign uio_oe  = 8'b00000000;

    // Unused inputs
    wire _unused = &{ena, ui_in, uio_in, 1'b0};

endmodule
