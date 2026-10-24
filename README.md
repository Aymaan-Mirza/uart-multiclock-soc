# UART-Controlled Multi-Clock-Domain SoC

Verilog design that receives commands over UART, runs register file and ALU operations, and sends results back. Two clock domains (50 MHz REF_CLK, 3.6864 MHz UART_CLK) connected with an async FIFO and synchronizers.

## Status
In progress: UART TX/RX