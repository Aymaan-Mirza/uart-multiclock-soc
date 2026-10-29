module uart_tx (
    input clk,
    input rst,
    input [7:0] p_data,
    input data_valid,
    input par_en,
    input par_typ,
    output tx_out,
    output busy
);

    wire ser_en, ser_done, ser_data, par_bit;
    wire [1:0] mux_sel;

    uart_tx_fsm u_fsm (
        .clk(clk), .rst(rst), .data_valid(data_valid), .par_en(par_en),
        .ser_done(ser_done), .ser_en(ser_en), .busy(busy), .mux_sel(mux_sel)
    );

    serializer u_ser (
        .clk(clk), .rst(rst), .data_valid(data_valid), .p_data(p_data),
        .ser_en(ser_en), .busy(busy), .ser_data(ser_data), .ser_done(ser_done)
    );

    parity_calc u_par (
        .clk(clk), .rst(rst), .data_valid(data_valid), .busy(busy),
        .p_data(p_data), .par_typ(par_typ), .par_bit(par_bit)
    );

    mux u_mux (
        .clk(clk), .rst(rst), .mux_sel(mux_sel),
        .ser_data(ser_data), .par_bit(par_bit), .tx_out(tx_out)
    );

endmodule