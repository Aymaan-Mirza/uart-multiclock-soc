module edge_bit_counter (
    input clk,
    input rst,
    input enable,
    input [5:0] prescale,
    output reg [3:0] bit_count,
    output reg [5:0] edge_count
);

    always @ (posedge clk or negedge rst) begin
        if (!rst) begin
            bit_count <= 0;
            edge_count <= 0;
        end else if (enable) begin
            if (edge_count == prescale-1) begin
                edge_count <= 0;
                bit_count <= bit_count + 1;
            end else begin
                edge_count <= edge_count + 1;
            end
        end else begin
            bit_count <= 0;
            edge_count <= 0;
        end
    end
    

endmodule