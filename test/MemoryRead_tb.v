`include "../config.v"
`timescale 10ns /1ns

module MemoryRead_tb();

reg src_clk;
reg set_phase;
reg [8:0] phase;
reg [(`DATA_LEN-1):0] data_wr;
reg [(`ROWS_BASE_2-1):0] addr_wr;
reg we;
wire [7:0] sinwave;

always #1 src_clk=~src_clk;

DDS dds_dut(
    .src_clk(src_clk),
    .set_phase(set_phase),
    .phase(phase),
    .data_wr(data_wr),
    .addr_wr(addr_wr),
    .we(we),
    .sinwave(sinwave)
);

integer data_file    ; // file handler
integer scan_file    ; // file handler
reg [(`DATA_LEN-1):0] captured_data;

initial begin
    //Set initial values to variables
    src_clk   = 1'b0;
    set_phase = 1'b0;
    phase     = 0;
    data_wr   = 0;
    addr_wr   = 0;
    we        = 0;
    
    //write memory
    we = 1'b1;
    data_file = $fopen("../../PythonScript/output.txt", "r");
    if (data_file == `NULL) begin
        $display("data_file handle was NULL");
        $finish;
    end
    while(!$feof(data_file)) begin
        scan_file = $fscanf(data_file, "%d\n", captured_data); 
        $display("val = %d",captured_data);
        data_wr = captured_data;
        #4
        addr_wr = addr_wr+1;
    end
    #4
    we = 1'b0;
    set_phase = 1'b1;
    phase = 90;
    #2
    set_phase = 1'b0;
    #200000

    $stop; 
end



endmodule