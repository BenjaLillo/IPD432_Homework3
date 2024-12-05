`timescale 1ns / 1ps
//Timed Moore machine

// Module header:-----------------------------
module FSM_readMAN(
	input logic clk, reset,
	input logic en_txMAN,
	input logic tx_busy,
	input logic [31:0] man,
	output logic tx_start,
	output logic done_txMAN,
	output logic [7:0] tx
);

	//FSM states type:
	enum logic [4:0] {IDLE, SET, READ, INCREMENT, FINISH} CurrentState, NextState;

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
    
    logic [7:0] P1, P2, P3, P4;
    always_ff @(posedge clk) begin
        if (CurrentState == IDLE) begin
            P1 = 0;
            P2 = 0;
            P3 = 0;
            P4 = 0;
        end
        else if (CurrentState == SET) begin
            P1 = man[7:0];
            P2 = man[15:8];
            P3 = man[23:16];
            P4 = man[31:24];
        end
    end

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
                done_txMAN = 0;
                if (en_txMAN)
                    NextState = SET;
                else
                    NextState = IDLE;
            end
            
            SET: begin
                tx = 0;
                tx_start = 0;
                done_txMAN = 0;
                NextState = READ;
            end
    
            READ: begin
                tx = (count == 0) ? P1 :
                     (count == 1) ? P2 :
                     (count == 2) ? P3 :
                     (count == 3) ? P4 : 0;
                tx_start = 1;
                done_txMAN = 0;
                if (~tx_busy)
                    NextState = INCREMENT;
                else
                    NextState = READ;
            end
    
            INCREMENT: begin
                tx = 0;
                tx_start = 0;
                done_txMAN = 0;
                if (count < 3)
                    NextState = READ;
                else if (count >= 3)
                    NextState = FINISH;
                else
                    NextState = INCREMENT;
            end
    
            FINISH: begin
                tx = 0;
                tx_start = 0;
                done_txMAN = 1;
                NextState = IDLE;
            end
    
            default: begin
                tx = 0;
                tx_start = 0;
                done_txMAN = 0;
                NextState = IDLE;
            end
        endcase
    end
    
endmodule