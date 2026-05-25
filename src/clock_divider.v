`default_nettype none
module clock_divider (
    input  wire clk,
    input  wire rst_n,
    output reg  slow_clk
);

    reg [23:0] count;

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            count    <= 24'd0;
            slow_clk <= 1'b0;
        end else begin
            if (count == 24'd9_999_999) begin
                count    <= 24'd0;
                slow_clk <= ~slow_clk;
            end else begin
                count <= count + 1'b1;
            end
        end
    end

endmodule
