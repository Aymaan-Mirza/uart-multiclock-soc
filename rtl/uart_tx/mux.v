module mux (
    input clk,
    input rst,
    input [1:0] mux_sel, 
    input ser_data,
    input par_bit,
    output reg tx_out
);

    localparam START  = 2'b00;
    localparam DATA   = 2'b01;
    localparam PARITY = 2'b10;
    localparam STOP   = 2'b11;

    always @ (posedge clk or negedge rst) begin
        if (!rst) begin
            tx_out <= 1;
        end else begin
            case (mux_sel)
                START: tx_out <= 0;
                DATA: tx_out <= ser_data;
                PARITY: tx_out <= par_bit;
                STOP: tx_out <= 1;
                default: tx_out <= 1;
            endcase
        end
    end

endmodule