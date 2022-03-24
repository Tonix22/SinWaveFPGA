`include "../config.v"

module DDS(
    input src_clk,
    input set_phase,
    input [9:0] phase,
    input ena,
    input [(`DATA_LEN-1):0] data_wr,
    input [(`ROWS_BASE_2-1):0] addr_wr,
    input we,
    output reg [6:0]sinwave
);

//DDS USE
reg wave_ena;
initial wave_ena=1'b1;


// Prescaler
wire en_clk = 1'b1;
wire wave_clk_en;

Prescaler #(.DIV(1000)) wave_clk 
(   .src_clk(src_clk),
    .en(en_clk),
    .clk_div(wave_clk_en)
);

//FSM
reg trigger;
reg [1:0]state_sel;
wire memdir;
wire data_pol;

FSM fsm
(
    .src_clk(src_clk),
    .set_phase(set_phase),
    .trigger(trigger),
    .state_sel(state_sel),
	.memdir(memdir),
	.data_pol(data_pol)
);
// Declare states
parameter S0 = 0, S1 = 1, S2 = 2, S3 = 3;
// State variables
parameter FORWARD = 0,BACKWARD = 1;
parameter POL_POS = 0,POL_NEG  = 1;

//PHASE
always @(posedge src_clk) begin

    if(set_phase && wave_ena==1'b1)begin
        wave_ena = 1'b0;
        if(phase < 255)
            state_sel = S0;
        else if (phase >= 256 && phase<512) 
        begin
            state_sel = S1;
        end
        else if (phase >= 512 && phase<768) 
        begin
            state_sel = S2;
        end
        else if (phase >= 768 && phase<1024) 
        begin
            state_sel = S3;
        end
    end
end

//MEMORY
wire [`DATA_LEN:0]data_rd;
reg  [(`ROWS_BASE_2-1):0] addr_rd;
wire [(`ROWS_BASE_2-1):0] addr = we?addr_wr:addr_rd;

Memory mem(
	.data(data_wr),
	.addr(addr_wr),
	.addr(we),
    .clk(src_clk),
	.q(data_rd)
);
// MEMORY WRITE




wire tic_tac = wave_ena?wave_clk_en:src_clk;
reg [3:0] huffman;
initial huffman = 4'b0000;

//address movment depenind on the states
always @(posedge src_clk) begin
    if(tic_tac) begin
        if(huffman == 4'b0) 
        begin
            if(memdir == FORWARD)
            begin 
                addr_rd = addr_rd +1'b1;
                if(addr_rd > `MEMORY_HEIGHT) begin 
                    trigger = 1'b1;
                end
            end
            else if (memdir == BACKWARD) 
            begin
                if(addr_rd == 1'b0) 
                begin
                    trigger = 1'b1;
                end
                else begin
                    addr_rd = addr_rd - 1'b1;
                end
            end
            read_mem = 1'b1;
        end
        else
            huffman = huffman-1'b0;
            read_mem = 1'b0;
    end
end

// MEMORY READ
reg read_mem;
initial read_mem = 1'b0;

always @(posedge src_clk) begin
    if(read_mem)
        huffman = data_rd&4'b1111;
        if(data_pol == POL_POS)
        begin
            sinwave = 127+(data_rd>>4);
        end
        else if(data_pol == POL_NEG) begin
            sinwave = 127-(data_rd>>4);
        end
end
    
endmodule