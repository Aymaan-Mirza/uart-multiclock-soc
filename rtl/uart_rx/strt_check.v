module strt_check (
    input clk,
    input rst,
    input strt_check_en,
    input sampled_bit,
    output reg strt_glitch
);

    always @ (posedge clk or negedge rst) begin
        if (!rst) begin
            strt_glitch <= 0;
        end else if (strt_check_en) begin
            strt_glitch <= sampled_bit;
        end else begin
            strt_glitch <= 0;
        end
    end

endmodule