`default_nettype none
module traffic_light_fsm (
    input  wire clk,
    input  wire rst_n,
    output reg  red,
    output reg  yellow,
    output reg  green
);

    reg [1:0] state;
    reg [2:0] timer;

    localparam S_RED    = 2'd0;
    localparam S_GREEN  = 2'd1;
    localparam S_YELLOW = 2'd2;

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            state <= S_RED;
            timer <= 3'd0;
        end else begin
            case (state)
                S_RED: begin
                    if (timer == 3'd3) begin
                        state <= S_GREEN;
                        timer <= 3'd0;
                    end else begin
                        timer <= timer + 1'b1;
                    end
                end

                S_GREEN: begin
                    if (timer == 3'd3) begin
                        state <= S_YELLOW;
                        timer <= 3'd0;
                    end else begin
                        timer <= timer + 1'b1;
                    end
                end

                S_YELLOW: begin
                    if (timer == 3'd1) begin
                        state <= S_RED;
                        timer <= 3'd0;
                    end else begin
                        timer <= timer + 1'b1;
                    end
                end

                default: begin
                    state <= S_RED;
                    timer <= 3'd0;
                end
            endcase
        end
    end

    always @(*) begin
        red    = 1'b0;
        yellow = 1'b0;
        green  = 1'b0;

        case (state)
            S_RED:    red    = 1'b1;
            S_GREEN:  green  = 1'b1;
            S_YELLOW: yellow = 1'b1;
            default:  red    = 1'b1;
        endcase
    end

endmodule
