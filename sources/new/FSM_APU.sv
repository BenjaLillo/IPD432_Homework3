`timescale 1ns / 1ps
//Timed Moore machine

// Module header:-----------------------------
module FSM_APU #(
    parameter N = 4, 
    parameter W = 8
    )(
	input logic clk, reset,
	input logic [N-1:0][W-1:0] A,
	input logic [N-1:0][W-1:0] B,
	input logic en_sum,
	input logic en_avg,
	input logic en_man,
	output logic [N-1:0][W-1:0] in_adder_tree,
	output logic done_sum,
	output logic done_avg,
	output logic done_man,
	output logic [N-1:0][W-1:0] RES
);

	//FSM states type:
	enum logic [7:0] {IDLE, SUM, AVG, MAN, FINISH_SUM, FINISH_AVG, FINISH_MAN, OPERATED} CurrentState, NextState;

	//Timer-related declarations:
	const logic [7:0] tmax = 30;
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

    
    // Memory FF logic
    always_ff @(posedge clk) begin
        if (reset)
            RES <= 0;
        else if (CurrentState == SUM) begin
            for (int i = 0; i<N; i++) begin
                RES[i] <= A[i] + B[i];
            end
        end
        else if (CurrentState == AVG) begin
            for (int i = 0; i<N; i++) begin
                RES[i] <= (A[i] + B[i]) >> 1;
            end
        end
        else if (CurrentState == MAN) begin
            for (int i = 0; i < N; i++) begin
                in_adder_tree[i] <= (A[i] > B[i]) ? (A[i] - B[i]) : (B[i] - A[i]);
            end
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
                done_sum = 0;
                done_avg = 0;
                done_man = 0;
                if (en_sum)
                    NextState = SUM;
                else if (en_avg)
                    NextState = AVG;
                else if (en_man)
                    NextState = MAN;
                else
                    NextState = IDLE;
            end
    
            SUM: begin
                done_sum = 0;
                done_avg = 0;
                done_man = 0;
                NextState = FINISH_SUM;
            end
    
            AVG: begin
                done_sum = 0;
                done_avg = 0;
                done_man = 0;
                NextState = FINISH_AVG;
            end
    
            MAN: begin
                done_sum = 0;
                done_avg = 0;
                done_man = 0;
                NextState = FINISH_MAN;
            end
            
            FINISH_SUM: begin
                done_sum = 1;
                done_avg = 0;
                done_man = 0;
                NextState = OPERATED;
            end
            
            FINISH_AVG: begin
                done_sum = 0;
                done_avg = 1;
                done_man = 0;
                NextState = OPERATED;
            end
            
            FINISH_MAN: begin
                done_sum = 0;
                done_avg = 0;
                done_man = 1;
                NextState = OPERATED;
            end
            
            OPERATED: begin
                done_sum = 0;
                done_avg = 0;
                done_man = 0;
                if (en_sum)
                    NextState = SUM;
                else if (en_avg)
                    NextState = AVG;
                else if (en_man)
                    NextState = MAN;
                else
                    NextState = IDLE;
            end
    
            default: begin
                done_sum = 0;
                done_avg = 0;
                done_man = 0;
                NextState = IDLE;
            end
        endcase
    end
    
endmodule