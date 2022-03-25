`include "../config.v"

module Prescaler#(parameter SRC_CLK=`SOURCE_CLK,parameter DIV=`Output_frequency)(
    input src_clk,en,
    input set_div,
    input [31:0]div,
    output reg clk_div
);

reg [31:0] MAX_CNT;
reg [31:0] cnt;
initial cnt = 0;
initial clk_div = 0;
initial MAX_CNT = `PRESCALE_CNT(SRC_CLK,DIV);

always @(posedge src_clk) begin
    if (en) begin
        cnt=cnt+1;
        if (cnt == MAX_CNT) begin
            cnt=0;
            clk_div=1;
        end

        if(cnt == 1) begin 
            clk_div = 0;
        end
    end
    if(set_div) begin
        MAX_CNT=`PRESCALE_CNT(SRC_CLK,div);
        cnt=0;
    end
end
    
endmodule