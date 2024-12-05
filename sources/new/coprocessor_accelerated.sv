`timescale 1ns / 1ps

module coprocessor_accelerated(
    input logic clk, resetN,
    input logic from_host,
    output logic to_host
    );
    
    // Parameters
    localparam BAUD_RATE  = 9600;
    localparam IN_NUMBER = 1024;
    localparam IN_WIDTH = 8;
    
    // Memory
    logic [IN_NUMBER-1:0][IN_WIDTH-1:0] A;
    logic [IN_NUMBER-1:0][IN_WIDTH-1:0] B;
    logic [IN_NUMBER-1:0][IN_WIDTH-1:0] RES;
    logic [IN_NUMBER-1:0][IN_WIDTH-1:0] in_adder_tree;
    logic [31:0] out_adder_tree;
    
    logic [7:0] rx_data, tx_data_A, tx_data_B, tx_data_RES, tx_data_MAN;
    logic tick, tick8, rx_ready, rx_ready_pulse, tx_start_A, tx_start_B, tx_start_RES, tx_start_MAN, tx_busy;
    logic done_txA, done_txB, done_txRES, done_txMAN, done_wrA, done_wrB, done_wr, done_sum, done_avg, done_man;
    logic en_txA, en_txB, en_txRES, en_txMAN, en_sum, en_avg, en_man, en_writeA, en_writeB;
    logic [10:0] CurrentState, NextState;

//    assign clk_out1 = clk;
//    assign clk_out5 = clk;
    
      clk_wiz_0 clock_wizard
       (
        // Clock out ports
        .clk_out1(clk_out1),     // output clk_out1
        .clk_out2(clk_out2),     // output clk_out2
        .clk_out3(clk_out3),     // output clk_out3
        .clk_out4(clk_out4),     // output clk_out4
        .clk_out5(clk_out5),     // output clk_out5
        .clk_out6(clk_out6),     // output clk_out6
        .clk_out7(clk_out7),     // output clk_out6
        // Status and control signals
        .reset(~resetN), // input reset
        .locked(locked),       // output locked
       // Clock in ports
        .clk_in1(clk)      // input clk_in1
    );
    
//    ila_0 ILA (
//        .clk(clk_out1), // input wire clk
    
    
//        .probe0(CurrentState), // input wire [10:0]  probe0  
//        .probe1(rx_ready), // input wire [0:0]  probe1 
//        .probe2(to_host) // input wire [0:0]  probe2
//    );
    
    uart_baud_tick_gen #(
        .CLK_FREQUENCY(100000000),
        .BAUD_RATE(BAUD_RATE),
        .OVERSAMPLING(1)
    ) baud_gen_inst (
        .clk(clk_out1),
        .enable(1'b1),
        .tick(tick)
    );
    
    uart_baud_tick_gen #(
        .CLK_FREQUENCY(100000000),
        .BAUD_RATE(BAUD_RATE),
        .OVERSAMPLING(8)
    ) baud_gen_inst_2 (
        .clk(clk_out1),
        .enable(1'b1),
        .tick(tick8)
    );
    
    uart_rx uart_rx(
        .clk(clk_out1),
        .reset(~resetN),
        .baud8_tick(tick8),
        .rx(from_host),
        .rx_data(rx_data),
        .rx_ready(rx_ready)
    );
    
    rise_to_pulse rise_to_pulse(
        .clk(clk_out1),
        .reset(~resetN),
        .in(rx_ready),
        .out(rx_ready_pulse)
    );
    
    uart_tx uart_tx(
        .clk(clk_out1),
        .reset(~resetN),
        .baud_tick(tick),
        .tx_start(tx_start_A || tx_start_B || tx_start_RES || tx_start_MAN),
        .tx_data(tx_data_A | tx_data_B | tx_data_RES | tx_data_MAN),
        .tx(to_host),
        .tx_busy(tx_busy)
    );
    
    FSM_master FSM_master (
        .clk(clk_out1),
        .reset(~resetN),
        .rx_ready(rx_ready_pulse),
        .done_txA(done_txA),
        .done_txB(done_txB),
        .done_txRES(done_txRES),
        .done_txMAN(done_txMAN),
        .done_wr(done_wrA || done_wrB),
        .done_sum(done_sum),
        .done_avg(done_avg),
        .done_man(done_man),
        .rx_data(rx_data),
        .en_txA(en_txA),
        .en_txB(en_txB),
        .en_txRES(en_txRES),
        .en_txMAN(en_txMAN),
        .en_sum(en_sum),
        .en_avg(en_avg),
        .en_man(en_man),
        .en_writeA(en_writeA),
        .en_writeB(en_writeB),
        .CurrentState(CurrentState),
        .NextState(NextState)
    );
    
    FSM_writeA #(
        .N(IN_NUMBER),
        .W(IN_WIDTH)
    )FSM_writeA(
        .clk(clk_out1),
        .reset(~resetN),
        .en_writeA(en_writeA),
        .rx_ready(rx_ready_pulse),
        .rx_data(rx_data),
        .done_wr(done_wrA),
        .A(A)
    );
    
    FSM_writeB #(
        .N(IN_NUMBER),
        .W(IN_WIDTH)
    )FSM_writeB(
        .clk(clk_out1),
        .reset(~resetN),
        .en_writeB(en_writeB),
        .rx_ready(rx_ready_pulse),
        .rx_data(rx_data),
        .done_wr(done_wrB),
        .B(B)
    );
    
    FSM_APU #(
        .N(IN_NUMBER),
        .W(IN_WIDTH)
    ) FSM_APU (
        .clk(clk_out5),
        .reset(~resetN),
        .A(A),
        .B(B),
        .en_sum(en_sum_apu),
        .en_avg(en_avg_apu),
        .en_man(en_man_apu),
        .in_adder_tree(in_adder_tree),
        .done_sum(done_sum),
        .done_avg(done_avg),
        .done_man(done_man),
        .RES(RES)
    );
    
    // Synchronization
    logic [2:0] en_signals_src, en_signals_dst;
    assign en_signals_src = {en_sum, en_avg, en_man};
    sync_enables sync_enables (
        .clk_src(clk_out1),
        .clk_dst(clk_out5),
        .resetN(resetN),
        .signal_in(en_signals_src),
        .signal_out(en_signals_dst)
    );
    assign {en_sum_apu, en_avg_apu, en_man_apu} = en_signals_dst;
    
    adder_tree #(
        .N(IN_NUMBER),
        .I(IN_WIDTH)
    ) adder_tree (
        .d(in_adder_tree),
        .q(out_adder_tree)
    );
    
    FSM_readA #(
        .N(IN_NUMBER),
        .W(IN_WIDTH)
    ) FSM_readA(
        .clk(clk_out1),
        .reset(~resetN),
        .tx_busy(tx_busy),
        .tx(tx_data_A),
        .tx_start(tx_start_A),
        .en_txA(en_txA),
        .done_txA(done_txA),
        .A(A)
    );
    
    FSM_readB #(
        .N(IN_NUMBER),
        .W(IN_WIDTH)
    ) FSM_readB(
        .clk(clk_out1),
        .reset(~resetN),
        .tx_busy(tx_busy),
        .tx(tx_data_B),
        .tx_start(tx_start_B),
        .en_txB(en_txB),
        .done_txB(done_txB),
        .B(B)
    );
    
    FSM_readRES #(
        .N(IN_NUMBER),
        .W(IN_WIDTH)
    ) FSM_readRES(
        .clk(clk_out1),
        .reset(~resetN),
        .tx_busy(tx_busy),
        .tx(tx_data_RES),
        .tx_start(tx_start_RES),
        .en_txRES(en_txRES),
        .done_txRES(done_txRES),
        .RES(RES)
    );
    
    FSM_readMAN FSM_readMAN(
        .clk(clk_out1),
        .reset(~resetN),
        .tx_busy(tx_busy),
        .tx(tx_data_MAN),
        .tx_start(tx_start_MAN),
        .en_txMAN(en_txMAN),
        .done_txMAN(done_txMAN),
        .man(out_adder_tree)
    );

    
endmodule