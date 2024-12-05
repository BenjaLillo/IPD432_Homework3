`timescale 1ns / 1ps
//Timed Moore machine

// Module header:-----------------------------
module FSM_readA #(
    parameter N = 4, 
    parameter W = 8
    )(
	input logic clk, reset,
	input logic en_txA,
	input logic tx_busy,
	input logic [N-1:0][W-1:0] A,
	output logic tx_start,
	output logic done_txA,
	output logic [7:0] tx
);

	//FSM states type:
	enum logic [3:0] {IDLE, READ, INCREMENT, FINISH} CurrentState, NextState;

	//Timer-related declarations:
	const logic [7:0] tmax = 30;
	logic [10:0] count;
	logic [7:0] t;

    // Timer :
//    always_ff @(posedge clk) begin
//        if (reset)
//            t <= 0;
//        else if (CurrentState != NextState)
//            t <= 0; //reset the timer when state changes
//        else if (t != tmax)
//            t <= t + 1;
//    end
    
    // Count FF logic
    logic count_incremented;
    always_ff @(posedge clk) begin
        if (reset || CurrentState == IDLE || CurrentState == FINISH) begin
            count <= 0;
            count_incremented <= 0;
        end
        else if (CurrentState == INCREMENT && !count_incremented) begin
            count <= count + 1;
            count_incremented <= 1;
        end
        else if (CurrentState != INCREMENT) begin
            count_incremented <= 0;
        end
    end
    
    // FSM state register:
    always_ff @(posedge clk) begin
        if (reset)
            CurrentState <= IDLE;
        else
            CurrentState <= NextState;
    end
    
    // FSM combinational logic:
    always_comb begin
        case (CurrentState)
            IDLE: begin
                tx = 0;
                tx_start = 0;
                done_txA = 0;
                if (en_txA)
                    NextState = READ;
                else
                    NextState = IDLE;
            end
    
            READ: begin
                tx = A[count];
                tx_start = 1;
                done_txA = 0;
                if (~tx_busy)
                    NextState = INCREMENT;
                else
                    NextState = READ;
            end
    
            INCREMENT: begin
                tx = 0;
                tx_start = 0;
                done_txA = 0;
                if (count < N-1)
                    NextState = READ;
                else if (count >= N-1)
                    NextState = FINISH;
                else
                    NextState = INCREMENT;
            end
    
            FINISH: begin
                tx = 0;
                tx_start = 0;
                done_txA = 1;
                NextState = IDLE;
            end
    
            default: begin
                tx = 0;
                tx_start = 0;
                done_txA = 0;
                NextState = IDLE;
            end
        endcase
    end
    
endmodule