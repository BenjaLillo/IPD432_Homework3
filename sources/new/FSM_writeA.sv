`timescale 1ns / 1ps
//Timed Moore machine

// Module header:-----------------------------
module FSM_writeA #(
    parameter N = 4, 
    parameter W = 8
    )(
	input logic clk, reset,
	input logic en_writeA,
	input logic rx_ready,
	input logic [7:0] rx_data,
	output logic done_wr,
	output logic [N-1:0][W-1:0] A
);

	//FSM states type:
	enum logic [3:0] {IDLE, SAVE, INCREMENT, FINISH, WRITTEN} CurrentState, NextState;

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
    
    // Memory FF logic
    always_ff @(posedge clk) begin
        if (reset)
            A <= 0;
        else if (CurrentState == SAVE)
            A[count] = rx_data;
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
                done_wr = 0;
                if (en_writeA)
                    NextState = SAVE;
                else
                    NextState = IDLE;
            end
    
            SAVE: begin
                done_wr = 0;
                if (rx_ready)
                    NextState = INCREMENT;
                else
                    NextState = SAVE;
            end
    
            INCREMENT: begin
                done_wr = 0;
                if (count < N-1)
                    NextState = SAVE;
                else if (count >= N-1)
                    NextState = FINISH;
                else
                    NextState = SAVE;
            end
    
            FINISH: begin
                done_wr = 1;
                NextState = WRITTEN;
            end
            
            WRITTEN: begin
                done_wr = 0;
                if (en_writeA)
                    NextState = SAVE;
                else
                    NextState = WRITTEN;
            end
    
            default: begin
                done_wr = 0;
                NextState = IDLE;
            end
        endcase
    end
    
endmodule