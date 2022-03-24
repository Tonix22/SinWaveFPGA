// 4-State Moore state machine

// A Moore machine's outputs are dependent only on the current state.
// The output is written only when the state changes.  (State
// transitions are synchronous.)
`include "../config.v"

module FSM
(
	input src_clk,
    input set_phase,
    input trigger,
    input [1:0]state_sel,
	output reg memdir,
	output reg data_pol
);
    // State variables
    parameter FORWARD = 0,BACKWARD = 1;
    parameter POL_POS = 0,POL_NEG  = 1;

	// Declare state register
	reg		[1:0]state;
    reg     next;
	 
	 // Declare states
	parameter S0 = 0, S1 = 1, S2 = 2, S3 = 3;


    always @(posedge src_clk) begin
        if(trigger)
            next = 1'b1;
    end

	// Determine the next state
	always @ (posedge src_clk) 
    begin
        if(!set_phase)
        begin 
			case (state)
				S0:
                    if(!next)
                        state <= S0;
                    else
					    state <= S1;
				S1:
                    if(!next)
                        state <= S1;
                    else
					    state <= S2;
				S2:
                    if(!next)
                        state <= S2;
                    else
					    state <= S3;
				S3:
                    if(!next)
                        state <= S3;
                    else
                        state <= S0 ;
			endcase
        end
        else
            state <= state_sel;
	end

    // Output depends only on the state
	always @ (state) begin
		case (state)
			S0:
            begin
				memdir   = FORWARD;
                data_pol = POL_POS;
                next = 1'b0;
            end
			S1:
            begin
				memdir   = BACKWARD;
                data_pol = POL_POS;
                next = 1'b0;
            end
			S2:
            begin
				memdir   = FORWARD;
                data_pol = POL_NEG;
                next = 1'b0;
            end
			S3:
            begin
				memdir   = BACKWARD;
                data_pol = POL_NEG;
                next = 1'b0;
            end
			default:
            begin
				memdir   = FORWARD;
                data_pol = POL_NEG;
                next = 1'b0;
            end
		endcase
	end

endmodule
