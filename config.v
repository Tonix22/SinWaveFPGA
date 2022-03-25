`define MHZ(freq) freq*1000000
`define PRESCALE_CNT(ref_clk,freq) (ref_clk/freq)

//CLOCKS
`define SOURCE_CLK `MHZ(50)
`define Output_frequency `MHZ(5)

//MEMORY
`define DATA_LEN 11
`define MEMORY_HEIGHT 109
`define ROWS_BASE_2 7 //2^7
`define NULL 0 
