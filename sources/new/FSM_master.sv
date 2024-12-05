`timescale 1ns / 1ps
//Timed Moore machine

// Module header:-----------------------------
module FSM_master
(
	input logic clk, reset,
	input logic rx_ready,
	input logic [7:0] rx_data,	
	input logic done_txA,
	input logic done_txB,
	input logic done_txRES,
	input logic done_txMAN,
	input logic done_wr,
	input logic done_sum,
	input logic done_avg,
	input logic done_man,
	output logic en_txA,
	output logic en_txB,
	output logic en_txRES,
	output logic en_txMAN,
	output logic en_sum,
	output logic en_avg,
	output logic en_man,
	output logic en_writeA,
	output logic en_writeB,
	output enum logic [10:0] {IDLE, FIRST, WRITEA, WRITEB, SUM, AVG, MAN, TXA, TXB, TXRES, TXMAN} CurrentState, NextState
);

	//Timer-related declarations:
	const logic [7:0] tmax = 30;
	logic [7:0] t;

	//Timer :
//	always_ff @(posedge clk) begin
//		if (reset)
//			t <= 0;
//		else if (CurrentState != NextState)
//			t <= 0; //reset the timer when state changes
//		else if (t != tmax)
//			t <= t + 1;
//	end

	//FSM state register:
	always_ff @(posedge clk) begin
		if (reset)
			CurrentState <= IDLE;
		else
			CurrentState <= NextState;
	end
 
	//FSM combinational logic:
	always_comb begin
		case (CurrentState)
			IDLE: begin
                en_txA = 0;
                en_txB = 0;
                en_txRES = 0;
                en_txMAN = 0;
                en_writeA = 0;
                en_writeB = 0;
                en_sum = 0;
                en_avg = 0;
                en_man = 0;
                if(rx_ready)
                    NextState = FIRST;
                else
                    NextState = IDLE;
			end

			FIRST: begin
                en_txA = 0;
                en_txB = 0;
                en_txRES = 0;
                en_txMAN = 0;
                en_writeA = 0;
                en_writeB = 0;
                en_sum = 0;
                en_avg = 0;
                en_man = 0;
                if (rx_data == "A")
                    NextState = WRITEA;
                else if (rx_data == "B")
                    NextState = WRITEB;
                else if (rx_data == "a")
                    NextState = TXA;
                else if (rx_data == "b")
                    NextState = TXB;
                else if (rx_data == "S")
                    NextState = SUM;
                else if (rx_data == "V")
                    NextState = AVG;
                else if (rx_data == "M")
                    NextState = MAN;
                else
                    NextState = FIRST;
			end

			WRITEA: begin
                en_txA = 0;
                en_txB = 0;
                en_txRES = 0;
                en_txMAN = 0;
                en_writeA = 1;
                en_writeB = 0;
                en_sum = 0;
                en_avg = 0;
                en_man = 0;
                if (done_wr)
                    NextState = IDLE;
                else
                    NextState = WRITEA;
			end

			WRITEB: begin
                en_txA = 0;
                en_txB = 0;
                en_txRES = 0;
                en_txMAN = 0;
                en_writeA = 0;
                en_writeB = 1;
                en_sum = 0;
                en_avg = 0;
                en_man = 0;
                if (done_wr)
                    NextState = IDLE;
                else
                    NextState = WRITEB;
			end

			SUM: begin
                en_txA = 0;
                en_txB = 0;
                en_txRES = 0;
                en_txMAN = 0;
                en_writeA = 0;
                en_writeB = 0;
                en_sum = 1;
                en_avg = 0;
                en_man = 0;
                if (done_sum)
                    NextState = TXRES;
                else
                    NextState = SUM;
			end

			AVG: begin
                en_txA = 0;
                en_txB = 0;
                en_txRES = 0;
                en_txMAN = 0;
                en_writeA = 0;
                en_writeB = 0;
                en_sum = 0;
                en_avg = 1;
                en_man = 0;
                if (done_avg)
                    NextState = TXRES;
                else
                    NextState = AVG;
			end

			MAN: begin
                en_txA = 0;
                en_txB = 0;
                en_txRES = 0;
                en_txMAN = 0;
                en_writeA = 0;
                en_writeB = 0;
                en_sum = 0;
                en_avg = 0;
                en_man = 1;
                if (done_man)
                    NextState = TXMAN;
                else
                    NextState = MAN;
			end

			TXA: begin
                en_txA = 1;
                en_txB = 0;
                en_txRES = 0;
                en_txMAN = 0;
                en_writeA = 0;
                en_writeB = 0;
                en_sum = 0;
                en_avg = 0;
                en_man = 0;
                if(done_txA)
                    NextState = IDLE;
                else
                    NextState = TXA;
			end
			
			TXB: begin
                en_txA = 0;
                en_txB = 1;
                en_txRES = 0;
                en_txMAN = 0;
                en_writeA = 0;
                en_writeB = 0;
                en_sum = 0;
                en_avg = 0;
                en_man = 0;
                if(done_txB)
                    NextState = IDLE;
                else
                    NextState = TXB;
			end
			
			TXRES: begin
                en_txA = 0;
                en_txB = 0;
                en_txRES = 1;
                en_txMAN = 0;
                en_writeA = 0;
                en_writeB = 0;
                en_sum = 0;
                en_avg = 0;
                en_man = 0;
                if(done_txRES)
                    NextState = IDLE;
                else
                    NextState = TXRES;
			end		
			
			TXMAN: begin
                en_txA = 0;
                en_txB = 0;
                en_txRES = 0;
                en_txMAN = 1;
                en_writeA = 0;
                en_writeB = 0;
                en_sum = 0;
                en_avg = 0;
                en_man = 0;
                if(done_txMAN)
                    NextState = IDLE;
                else
                    NextState = TXMAN;
			end	

			default: begin
                // Default assignments to prevent latches
                en_txA = 0;
                en_txB = 0;
                en_txRES = 0;
                en_txMAN = 0;
                en_writeA = 0;
                en_writeB = 0;
                en_sum = 0;
                en_avg = 0;
                en_man = 0;
                NextState = IDLE;
			end
		endcase
	end
endmodule 