module uart_rx_fsm (
    input clk,
    input rst,
    input rx_in,
    input par_en,
    input [5:0] prescale,
    input [5:0] edge_count,
    input [3:0] bit_count,
    input par_err,
    input strt_glitch,
    input stp_err,
    output reg enable,
    output reg data_sampl_en,
    output reg deser_en,
    output reg strt_check_en,
    output reg parity_check_en,
    output reg stp_check_en,
    output reg data_valid,
    output reg par_err_flag,
    output reg stp_err_flag
);

    
    localparam S_IDLE   = 3'b000;
    localparam S_START  = 3'b001;
    localparam S_DATA   = 3'b010;
    localparam S_PARITY = 3'b011;
    localparam S_STOP   = 3'b100;

    reg [2:0] current_state, next_state;

    
    wire [5:0] last = prescale - 1;
    wire [5:0] chk  = (prescale >> 1) + 3;
    wire at_last = (edge_count == last);
    wire at_chk  = (edge_count == chk);

    wire glitch_abort = (current_state == S_START) && at_chk && strt_glitch;
    wire stop_done    = (current_state == S_STOP)  && at_chk;

    
    always @ (posedge clk or negedge rst) begin
        if (!rst) current_state <= S_IDLE;
        else      current_state <= next_state;
    end

    
    always @ (*) begin
        next_state = current_state;
        case (current_state)
            S_IDLE:   if (!rx_in) next_state = S_START;
            S_START:  if (glitch_abort)    next_state = S_IDLE;
                      else if (at_last)    next_state = S_DATA;
            S_DATA:   if (at_last && bit_count == 4'd8) begin
                          if (par_en) next_state = S_PARITY;
                          else        next_state = S_STOP;
                      end
            S_PARITY: if (at_last) next_state = S_STOP;
            S_STOP:   if (stop_done) next_state = S_IDLE;
            default:  next_state = S_IDLE;
        endcase
    end


    always @ (*) begin
        enable          = 0;
        data_sampl_en   = 0;
        deser_en        = 0;
        strt_check_en   = 0;
        parity_check_en = 0;
        stp_check_en    = 0;
        case (current_state)
            S_IDLE:   enable = ~rx_in;
            S_START:  begin enable = ~glitch_abort; data_sampl_en = 1; strt_check_en = 1; end
            S_DATA:   begin enable = 1; data_sampl_en = 1; deser_en = at_last; end
            S_PARITY: begin enable = 1; data_sampl_en = 1; parity_check_en = 1; end
            S_STOP:   begin enable = ~stop_done; data_sampl_en = 1; stp_check_en = 1; end
            default:  ;
        endcase
    end

    always @ (posedge clk or negedge rst) begin
        if (!rst) begin
            data_valid   <= 0;
            par_err_flag <= 0;
            stp_err_flag <= 0;
        end else begin
            data_valid <= stop_done && !stp_err && !par_err_flag;
            if (current_state == S_IDLE && !rx_in) begin
                par_err_flag <= 0;
                stp_err_flag <= 0;
            end else begin
                if (current_state == S_PARITY && at_last) par_err_flag <= par_err;
                if (stop_done) stp_err_flag <= stp_err;
            end
        end
    end

endmodule