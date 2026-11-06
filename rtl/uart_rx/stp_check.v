module stp_check (
    input clk,
    input rst,
    input sampled_bit,
    input stp_check_en,
    output reg stp_err
);

    always @ (posedge clk or negedge rst) begin
        if (!rst) begin
            stp_err <= 0;
        end else if (stp_check_en) begin
            stp_err <= ~sampled_bit;
        end else begin
            stp_err <= 0;
        end
    end

endmodule