module serializer (
    input clk,
    input rst,
    input data_valid,
    input [7:0] p_data,
    input ser_en,
    input busy,
    output reg ser_data,
    output reg ser_done
);
    reg [7:0] data_reg;
    reg [2:0] count;

    always @ (posedge clk or negedge rst) begin
        if (!rst) begin
            ser_data <= 0;
            data_reg <= 0;
            count <= 0;
            ser_done <= 0;
        end else begin
            if (data_valid && ~(busy)) begin
                data_reg <= p_data;
            end else if (ser_en) begin
                ser_data <= data_reg[count];
                count <= count + 1;
            end else begin
                count <= 0;
            end
            ser_done <= (ser_en & (count == 7));
        end
    end


endmodule