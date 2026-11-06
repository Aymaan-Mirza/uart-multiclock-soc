module data_sampling (
    input clk,
    input rst,
    input rx_in,
    input [5:0] prescale,
    input data_sampl_en,
    input [5:0] edge_cnt,
    output sampled_bit 
);

    reg [2:0] samples;

    always @ (posedge clk or negedge rst) begin
        if (!rst) begin
            samples <= 0;
        end else if (data_sampl_en) begin
            if (edge_cnt == ((prescale >> 1)+ 1)) begin
                samples [0] <= rx_in;
            end else if (edge_cnt == (prescale >> 1)) begin
                samples [1] <= rx_in;
            end else if (edge_cnt == ((prescale >> 1) - 1)) begin
                samples [2] <= rx_in;
            end
        end
    end

    assign sampled_bit = (samples[0] & samples[1]) | (samples[1] & samples[2]) | (samples[0] & samples[2]);


endmodule