`default_nettype none
`timescale 1ns / 1ps

module tt_um_example (
    input  wire [7:0] ui_in,    // Dedicated inputs
    output wire [7:0] uo_out,   // Dedicated outputs
    input  wire [7:0] uio_in,   // IOs: Input path
    output wire [7:0] uio_out,  // IOs: Output path
    output wire [7:0] uio_oe,   // IOs: Enable path
    input  wire       ena,      // always 1 when the design is powered
    input  wire       clk,      // clock
    input  wire       rst_n     // reset_n - low to reset
);

    wire tick;
    wire red;
    wire yellow;
    wire green;

    // Submodule 1: clock divider
    clock_divider u_div (
        .clk  (clk),
        .rst_n(rst_n),
        .tick (tick)
    );

    // Submodule 2: traffic light controller
    traffic_light_fsm u_fsm (
        .clk   (clk),
        .rst_n (rst_n),
        .tick  (tick),
        .red   (red),
        .yellow(yellow),
        .green (green)
    );

    // Output mapping
    // uo_out[0] = red
    // uo_out[1] = yellow
    // uo_out[2] = green
    assign uo_out = {5'b00000, green, yellow, red};

    // No bidirectional pins used
    assign uio_out = 8'b00000000;
    assign uio_oe  = 8'b00000000;

    // Unused inputs
    wire _unused = &{ena, ui_in, uio_in, 1'b0};

endmodule


module clock_divider (
    input  wire clk,
    input  wire rst_n,
    output reg  tick
);

    reg [3:0] count;

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            count <= 4'd0;
            tick  <= 1'b0;
        end else begin
            if (count == 4'd9) begin
                count <= 4'd0;
                tick  <= 1'b1;
            end else begin
                count <= count + 1'b1;
                tick  <= 1'b0;
            end
        end
    end

endmodule


module traffic_light_fsm (
    input  wire clk,
    input  wire rst_n,
    input  wire tick,
    output reg  red,
    output reg  yellow,
    output reg  green
);

    reg [1:0] state;
    reg [1:0] timer;

    localparam RED    = 2'd0;
    localparam GREEN  = 2'd1;
    localparam YELLOW = 2'd2;

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            state <= RED;
            timer <= 2'd0;
        end else if (tick) begin
            case (state)
                RED: begin
                    if (timer == 2'd2) begin
                        state <= GREEN;
                        timer <= 2'd0;
                    end else begin
                        timer <= timer + 1'b1;
                    end
                end

                GREEN: begin
                    if (timer == 2'd2) begin
                        state <= YELLOW;
                        timer <= 2'd0;
                    end else begin
                        timer <= timer + 1'b1;
                    end
                end

                YELLOW: begin
                    state <= RED;
                    timer <= 2'd0;
                end

                default: begin
                    state <= RED;
                    timer <= 2'd0;
                end
            endcase
        end
    end

    always @(*) begin
        red    = 1'b0;
        yellow = 1'b0;
        green  = 1'b0;

        case (state)
            RED:    red    = 1'b1;
            GREEN:  green  = 1'b1;
            YELLOW: yellow = 1'b1;
            default: red   = 1'b1;
        endcase
    end

endmodule

`default_nettype wire
