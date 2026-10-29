module uart_tx_fsm (
    input clk,
    input rst,
    input data_valid,
    input par_en,
    input ser_done,
    output reg ser_en,
    output reg busy,
    output reg [1:0] mux_sel
);


    localparam S_IDLE   = 3'b000;
    localparam S_START  = 3'b001;
    localparam S_DATA   = 3'b010;
    localparam S_PARITY = 3'b011;
    localparam S_STOP   = 3'b100;


    localparam M_START  = 2'b00;
    localparam M_DATA   = 2'b01;
    localparam M_PARITY = 2'b10;
    localparam M_STOP   = 2'b11;

    reg [2:0] current_state, next_state;

    always @ (posedge clk or negedge rst) begin
        if (!rst) current_state <= S_IDLE;
        else      current_state <= next_state;
    end

    always @ (*) begin
        next_state = current_state;   
        case (current_state)
            S_IDLE:   if (data_valid) next_state = S_START;
            S_START:  next_state = S_DATA;
            S_DATA:   if (ser_done) begin
                          if (par_en) next_state = S_PARITY;
                          else        next_state = S_STOP;
                      end
            S_PARITY: next_state = S_STOP;
            S_STOP:   next_state = S_IDLE;
            default:  next_state = S_IDLE;
        endcase
    end

 
    always @ (*) begin
        ser_en = 0;                     
        busy = 0;
        mux_sel = M_STOP;
        case (current_state)
            S_IDLE:   begin ser_en = 0; busy = 0; mux_sel = M_STOP; end
            S_START:  begin ser_en = 1; busy = 1; mux_sel = M_START;end
            S_DATA:   begin ser_en = 1; busy = 1; mux_sel = M_DATA; end
            S_PARITY: begin ser_en = 0; busy = 1; mux_sel = M_PARITY; end
            S_STOP:   begin ser_en = 0; busy = 1; mux_sel = M_STOP; end
            default:  begin ser_en = 0; busy = 0; mux_sel = M_STOP; end
        endcase
    end

endmodule