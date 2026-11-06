module deserializer (
    input clk,
    input rst,
    input sampled_bit,
    input deser_en,
    output reg [7:0] p_data
);

    always @ (posedge clk or negedge rst) begin
        if (!rst) begin
            p_data <= 0;
        end else if (deser_en) begin
            p_data <= {sampled_bit, p_data [7:1]};
        end
    end

endmodule