module parity_check (
    input clk,
    input rst,
    input parity_check_en,
    input sampled_bit,
    input par_typ,
    input [7:0] p_data,
    output reg par_err
);

    always @ (posedge clk or negedge rst) begin
        if (!rst) begin
            par_err <= 0;
        end else if (parity_check_en) begin
            par_err <= ((^p_data) ^ par_typ) ^ sampled_bit;
        end else begin
            par_err <= 0;
        end
    end

endmodule