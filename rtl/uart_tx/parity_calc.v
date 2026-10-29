module parity_calc (
    input clk,
    input rst,
    input data_valid,
    input busy,
    input [7:0] p_data,
    input par_typ,
    output reg par_bit
);

    reg [7:0] data_reg;

    always @ (posedge clk or negedge rst) begin
        if (!rst) begin
            par_bit <= 0;
            data_reg <= 0;
        end else begin
            if (data_valid && ~(busy)) begin
                data_reg <= p_data;
            end
            par_bit <= (^data_reg) ^ par_typ;
        end
    end

endmodule