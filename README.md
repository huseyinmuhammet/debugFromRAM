# debugFromRAM
I designed FSM that transfers 32 bits data, in 16384 addresses, to Matlab. Since FT2232HQ could transfer only 8 bits data, I divided each data into 4 pieces. After that I combined these data pieces into Matlab to make 32 bits data which has 16384 addresses.   
I wrote FSM_DEBUG and TOP_DEBUG. UART_TX_CTRL and debouncer were already written code by others.
