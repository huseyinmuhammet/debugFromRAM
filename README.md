# debugFromRAM
I designed FSM that transfers 32 bits data, in 16384 addresses, to Matlab. However, FT2232HQ could transfer only 8 bits data. For this reason, I divided each data into 4 pieces.
I wrote FSM_DEBUG and TOP_DEBUG. UART_TX_CTRL and debouncer were already written code by others.
