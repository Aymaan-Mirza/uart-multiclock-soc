module uart_rx (
    input clk,
    input rst,
    input rx_in,
    input par_en,
    input par_typ,
    input [5:0] prescale,
    output [7:0] p_data,
    output data_valid,
    output par_err,
    output stp_err
);

    wire enable, data_sampl_en, deser_en;
    wire strt_check_en, parity_check_en, stp_check_en;
    wire sampled_bit, strt_glitch, par_err_chk, stp_err_chk;
    wire [5:0] edge_count;
    wire [3:0] bit_count;

    uart_rx_fsm u_fsm (
        .clk(clk), .rst(rst), .rx_in(rx_in), .par_en(par_en), .prescale(prescale),
        .edge_count(edge_count), .bit_count(bit_count),
        .par_err(par_err_chk), .strt_glitch(strt_glitch), .stp_err(stp_err_chk),
        .enable(enable), .data_sampl_en(data_sampl_en), .deser_en(deser_en),
        .strt_check_en(strt_check_en), .parity_check_en(parity_check_en),
        .stp_check_en(stp_check_en), .data_valid(data_valid),
        .par_err_flag(par_err), .stp_err_flag(stp_err)
    );

    edge_bit_counter u_ebc (
        .clk(clk), .rst(rst), .enable(enable), .prescale(prescale),
        .bit_count(bit_count), .edge_count(edge_count)
    );

    data_sampling u_samp (
        .clk(clk), .rst(rst), .rx_in(rx_in), .prescale(prescale),
        .data_sampl_en(data_sampl_en), .edge_cnt(edge_count), .sampled_bit(sampled_bit)
    );

    deserializer u_deser (
        .clk(clk), .rst(rst), .sampled_bit(sampled_bit), .deser_en(deser_en), .p_data(p_data)
    );

    strt_check u_strt (
        .clk(clk), .rst(rst), .strt_check_en(strt_check_en),
        .sampled_bit(sampled_bit), .strt_glitch(strt_glitch)
    );

    parity_check u_par (
        .clk(clk), .rst(rst), .parity_check_en(parity_check_en), .sampled_bit(sampled_bit),
        .par_typ(par_typ), .p_data(p_data), .par_err(par_err_chk)
    );

    stp_check u_stp (
        .clk(clk), .rst(rst), .stp_check_en(stp_check_en),
        .sampled_bit(sampled_bit), .stp_err(stp_err_chk)
    );

endmodule