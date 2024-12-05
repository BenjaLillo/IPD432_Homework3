#set_max_delay -from [get_pins FSM_master/FSM_onehot_CurrentState_reg[8]/C] -to [get_pins FSM_APU/FSM_onehot_CurrentState_reg[0]/D] 7.0
#set_max_delay -from [get_pins FSM_master/FSM_onehot_CurrentState_reg[8]/C] -to [get_pins FSM_APU/FSM_onehot_CurrentState_reg[1]/D] 7.0
#set_max_delay -from [get_pins FSM_master/FSM_onehot_CurrentState_reg[6]/C] -to [get_pins FSM_APU/FSM_onehot_CurrentState_reg[6]/D] 7.0
#set_max_delay -from [get_pins FSM_master/FSM_onehot_CurrentState_reg[6]/C] -to [get_pins FSM_APU/FSM_onehot_CurrentState_reg[4]_rep/D] 7.0
#set_max_delay -from [get_pins FSM_master/FSM_onehot_CurrentState_reg[6]/C] -to [get_pins FSM_APU/FSM_onehot_CurrentState_reg[4]_rep__0/D] 7.0
#set_max_delay -from [get_pins FSM_master/FSM_onehot_CurrentState_reg[6]/C] -to [get_pins FSM_APU/FSM_onehot_CurrentState_reg[4]_rep__1/D] 7.0
#set_max_delay -from [get_pins FSM_master/FSM_onehot_CurrentState_reg[6]/C] -to [get_pins FSM_APU/FSM_onehot_CurrentState_reg[4]_rep__10/D] 7.0
#set_max_delay -from [get_pins FSM_master/FSM_onehot_CurrentState_reg[6]/C] -to [get_pins FSM_APU/FSM_onehot_CurrentState_reg[4]_rep__11/D] 7.0
#set_max_delay -from [get_pins FSM_master/FSM_onehot_CurrentState_reg[6]/C] -to [get_pins FSM_APU/FSM_onehot_CurrentState_reg[4]_rep__12/D] 7.0

## Voltage levels
set_property CFGBVS VCCO [current_design]
set_property CONFIG_VOLTAGE 3.3 [current_design]

# Clocks
set_property -dict { PACKAGE_PIN E3    IOSTANDARD LVCMOS33 } [get_ports { clk }]; #IO_L12P_T1_MRCC_35 Sch=clk100mhz
create_clock -add -name sys_clk_pin -period 10.00 -waveform {0 5} [get_ports { clk }];

set_clock_groups -group {clk_out1_clk_wiz_0 clk_out5_clk_wiz_0} -logically_exclusive
set_clock_groups -group {clk_out1_clk_wiz_0 clk_out5_clk_wiz_0_1} -logically_exclusive
set_clock_groups -group {clk_out1_clk_wiz_0_1 clk_out5_clk_wiz_0} -logically_exclusive
set_clock_groups -group {clk_out1_clk_wiz_0_1 clk_out5_clk_wiz_0_1} -logically_exclusive
set_clock_groups -group {clk_out5_clk_wiz_0 clk_out1_clk_wiz_0} -logically_exclusive
set_clock_groups -group {clk_out5_clk_wiz_0 clk_out1_clk_wiz_0_1} -logically_exclusive
set_clock_groups -group {clk_out5_clk_wiz_0_1 clk_out1_clk_wiz_0} -logically_exclusive
set_clock_groups -group {clk_out5_clk_wiz_0_1 clk_out1_clk_wiz_0_1} -logically_exclusive



#create_generated_clock -source [get_pins clk_wiz_1/clk] -name clk_out1_clk_wiz_1 [get_pins clk_wiz_1/clk_out1]
#create_generated_clock -source [get_pins clk_wiz_1/clk] -name clk_out4_clk_wiz_1 [get_pins clk_wiz_1/clk_out4]
#create_generated_clock -source [get_pins clk_wiz_1/clk] -name clk_out5_clk_wiz_1 [get_pins clk_wiz_1/clk_out5]
#create_generated_clock -source [get_pins clk_wiz_1/clk_in] -divided_by 1 -name clk_out1_clk_wiz_1 [get_pins clk_wiz_1/clk_out1]
#create_generated_clock -source [get_pins clk_wiz_1/clk_in] -divided_by 128 -name clk_out4_clk_wiz_1 [get_pins clk_wiz_1/clk_out4]
#create_generated_clock -source [get_pins clk_wiz_1/clk_in] -divided_by 16384 -name clk_out5_clk_wiz_1 [get_pins clk_wiz_1/clk_out5]



## CPU reset button
set_property -dict {PACKAGE_PIN C12 IOSTANDARD LVCMOS33} [get_ports resetN]

## USB UART interface
set_property -dict {PACKAGE_PIN D4 IOSTANDARD LVCMOS33} [get_ports to_host]
set_property -dict {PACKAGE_PIN C4 IOSTANDARD LVCMOS33} [get_ports from_host]
#set_property -dict {PACKAGE_PIN E5 IOSTANDARD LVCMOS33} [get_ports uart_cts]
#set_property -dict {PACKAGE_PIN D3      IOSTANDARD LVCMOS33} [get_ports uart_rts]

## 7 Segment display
#set_property PACKAGE_PIN J17 [get_ports {an[0]}]
#set_property PACKAGE_PIN J18 [get_ports {an[1]}]
#set_property PACKAGE_PIN T9 [get_ports {an[2]}]
#set_property PACKAGE_PIN J14 [get_ports {an[3]}]
#set_property PACKAGE_PIN P14 [get_ports {an[4]}]
#set_property PACKAGE_PIN T14 [get_ports {an[5]}]
#set_property PACKAGE_PIN K2 [get_ports {an[6]}]
#set_property PACKAGE_PIN U13 [get_ports {an[7]}]
#set_property IOSTANDARD LVCMOS33 [get_ports {an[7]}]
#set_property IOSTANDARD LVCMOS33 [get_ports {an[6]}]
#set_property IOSTANDARD LVCMOS33 [get_ports {an[5]}]
#set_property IOSTANDARD LVCMOS33 [get_ports {an[4]}]
#set_property IOSTANDARD LVCMOS33 [get_ports {an[3]}]
#set_property IOSTANDARD LVCMOS33 [get_ports {an[2]}]
#set_property IOSTANDARD LVCMOS33 [get_ports {an[1]}]
#set_property IOSTANDARD LVCMOS33 [get_ports {an[0]}]
#set_property PACKAGE_PIN T10 [get_ports {seg[0]}]
#set_property PACKAGE_PIN R10 [get_ports {seg[1]}]
#set_property PACKAGE_PIN K16 [get_ports {seg[2]}]
#set_property PACKAGE_PIN K13 [get_ports {seg[3]}]
#set_property PACKAGE_PIN P15 [get_ports {seg[4]}]
#set_property PACKAGE_PIN T11 [get_ports {seg[5]}]
#set_property PACKAGE_PIN L18 [get_ports {seg[6]}]
#set_property IOSTANDARD LVCMOS33 [get_ports {seg[6]}]
#set_property IOSTANDARD LVCMOS33 [get_ports {seg[5]}]
#set_property IOSTANDARD LVCMOS33 [get_ports {seg[4]}]
#set_property IOSTANDARD LVCMOS33 [get_ports {seg[3]}]
#set_property IOSTANDARD LVCMOS33 [get_ports {seg[2]}]
#set_property IOSTANDARD LVCMOS33 [get_ports {seg[1]}]
#set_property IOSTANDARD LVCMOS33 [get_ports {seg[0]}]

## Push buttons
#set_property -dict {PACKAGE_PIN M17 IOSTANDARD LVCMOS33} [get_ports {button[0]}]; # Right
#set_property -dict {PACKAGE_PIN P17 IOSTANDARD LVCMOS33} [get_ports {button[1]}]; # Left
#set_property -dict {PACKAGE_PIN P18 IOSTANDARD LVCMOS33} [get_ports {button[2]}]; # Down
#set_property -dict {PACKAGE_PIN M18 IOSTANDARD LVCMOS33} [get_ports {button[3]}]; # Up
#set_property -dict {PACKAGE_PIN N17 IOSTANDARD LVCMOS33} [get_ports button_c]

## Switches
#set_property -dict {PACKAGE_PIN J15 IOSTANDARD LVCMOS33} [get_ports {switches[0]}]
#set_property -dict {PACKAGE_PIN L16 IOSTANDARD LVCMOS33} [get_ports {switches[1]}]
#set_property -dict {PACKAGE_PIN M13 IOSTANDARD LVCMOS33} [get_ports {switches[2]}]
#set_property -dict {PACKAGE_PIN R15 IOSTANDARD LVCMOS33} [get_ports {switches[3]}]
#set_property -dict {PACKAGE_PIN R17 IOSTANDARD LVCMOS33} [get_ports {switches[4]}]
#set_property -dict {PACKAGE_PIN T18 IOSTANDARD LVCMOS33} [get_ports {switches[5]}]
#set_property -dict {PACKAGE_PIN U18 IOSTANDARD LVCMOS33} [get_ports {switches[6]}]
#set_property -dict {PACKAGE_PIN R13 IOSTANDARD LVCMOS33} [get_ports {switches[7]}]
#set_property -dict {PACKAGE_PIN T8  IOSTANDARD LVCMOS18} [get_ports {switches[8]}]
#set_property -dict {PACKAGE_PIN U8  IOSTANDARD LVCMOS18} [get_ports {switches[9]}]
#set_property -dict {PACKAGE_PIN R16 IOSTANDARD LVCMOS33} [get_ports {switches[10]}]
#set_property -dict {PACKAGE_PIN T13 IOSTANDARD LVCMOS33} [get_ports {switches[11]}]
#set_property -dict {PACKAGE_PIN H6  IOSTANDARD LVCMOS33} [get_ports {switches[12]}]
#set_property -dict {PACKAGE_PIN U12 IOSTANDARD LVCMOS33} [get_ports {switches[13]}]
#set_property -dict {PACKAGE_PIN U11 IOSTANDARD LVCMOS33} [get_ports {switches[14]}]
#set_property -dict {PACKAGE_PIN V10 IOSTANDARD LVCMOS33} [get_ports {switches[15]}]

## LEDs
#set_property -dict {PACKAGE_PIN H17 IOSTANDARD LVCMOS33} [get_ports {leds[0]}]
#set_property -dict {PACKAGE_PIN K15 IOSTANDARD LVCMOS33} [get_ports {leds[1]}]
#set_property -dict {PACKAGE_PIN J13 IOSTANDARD LVCMOS33} [get_ports {leds[2]}]
#set_property -dict {PACKAGE_PIN N14 IOSTANDARD LVCMOS33} [get_ports {leds[3]}]
#set_property -dict {PACKAGE_PIN R18 IOSTANDARD LVCMOS33} [get_ports {leds[4]}]
#set_property -dict {PACKAGE_PIN V17 IOSTANDARD LVCMOS33} [get_ports {leds[5]}]
#set_property -dict {PACKAGE_PIN U17 IOSTANDARD LVCMOS33} [get_ports {leds[6]}]
#set_property -dict {PACKAGE_PIN U16 IOSTANDARD LVCMOS33} [get_ports {leds[7]}]
#set_property -dict {PACKAGE_PIN V16 IOSTANDARD LVCMOS33} [get_ports {leds[8]}]
#set_property -dict {PACKAGE_PIN T15 IOSTANDARD LVCMOS33} [get_ports {leds[9]}]
#set_property -dict {PACKAGE_PIN U14 IOSTANDARD LVCMOS33} [get_ports {leds[10]}]
#set_property -dict {PACKAGE_PIN T16 IOSTANDARD LVCMOS33} [get_ports {leds[11]}]
#set_property -dict {PACKAGE_PIN V15 IOSTANDARD LVCMOS33} [get_ports {leds[12]}]
#set_property -dict {PACKAGE_PIN V14 IOSTANDARD LVCMOS33} [get_ports {leds[13]}]
#set_property -dict {PACKAGE_PIN V12 IOSTANDARD LVCMOS33} [get_ports {leds[14]}]
#set_property -dict {PACKAGE_PIN V11 IOSTANDARD LVCMOS33} [get_ports {leds[15]}]

## Color LEDs
#set_property -dict {PACKAGE_PIN N15 IOSTANDARD LVCMOS33} [get_ports {rgb_led16[2]}]
#set_property -dict {PACKAGE_PIN M16 IOSTANDARD LVCMOS33} [get_ports {rgb_led16[1]}]
#set_property -dict {PACKAGE_PIN R12 IOSTANDARD LVCMOS33} [get_ports {rgb_led16[0]}]
#set_property -dict {PACKAGE_PIN N16 IOSTANDARD LVCMOS33} [get_ports rgb_led17[2]]; # R
#set_property -dict {PACKAGE_PIN R11 IOSTANDARD LVCMOS33} [get_ports rgb_led17[1]]; # G
#set_property -dict {PACKAGE_PIN G14 IOSTANDARD LVCMOS33} [get_ports rgb_led17[0]]; # B

## Micro SD connector
#set_property -dict {PACKAGE_PIN E2 IOSTANDARD LVCMOS33} [get_ports {SD_RESET}]
#set_property -dict {PACKAGE_PIN A1 IOSTANDARD LVCMOS33} [get_ports {SD_CD}]
#set_property -dict {PACKAGE_PIN B1 IOSTANDARD LVCMOS33} [get_ports {SD_SCK}]
#set_property -dict {PACKAGE_PIN C1 IOSTANDARD LVCMOS33} [get_ports {SD_CMD}]
#set_property -dict {PACKAGE_PIN C2 IOSTANDARD LVCMOS33} [get_ports {SD_DAT[0]}]
#set_property -dict {PACKAGE_PIN E1 IOSTANDARD LVCMOS33} [get_ports {SD_DAT[1]}]
#set_property -dict {PACKAGE_PIN F1 IOSTANDARD LVCMOS33} [get_ports {SD_DAT[2]}]
#set_property -dict {PACKAGE_PIN D2 IOSTANDARD LVCMOS33} [get_ports {SD_DAT[3]}]

## VGA Connector
#set_property -dict {PACKAGE_PIN A3  IOSTANDARD LVCMOS33} [get_ports {vga_r[0]}]
#set_property -dict {PACKAGE_PIN B4  IOSTANDARD LVCMOS33} [get_ports {vga_r[1]}]
#set_property -dict {PACKAGE_PIN C5  IOSTANDARD LVCMOS33} [get_ports {vga_r[2]}]
#set_property -dict {PACKAGE_PIN A4  IOSTANDARD LVCMOS33} [get_ports {vga_r[3]}]
#set_property -dict {PACKAGE_PIN C6  IOSTANDARD LVCMOS33} [get_ports {vga_g[0]}]
#set_property -dict {PACKAGE_PIN A5  IOSTANDARD LVCMOS33} [get_ports {vga_g[1]}]
#set_property -dict {PACKAGE_PIN B6  IOSTANDARD LVCMOS33} [get_ports {vga_g[2]}]
#set_property -dict {PACKAGE_PIN A6  IOSTANDARD LVCMOS33} [get_ports {vga_g[3]}]
#set_property -dict {PACKAGE_PIN B7  IOSTANDARD LVCMOS33} [get_ports {vga_b[0]}]
#set_property -dict {PACKAGE_PIN C7  IOSTANDARD LVCMOS33} [get_ports {vga_b[1]}]
#set_property -dict {PACKAGE_PIN D7  IOSTANDARD LVCMOS33} [get_ports {vga_b[2]}]
#set_property -dict {PACKAGE_PIN D8  IOSTANDARD LVCMOS33} [get_ports {vga_b[3]}]
#set_property -dict {PACKAGE_PIN B11 IOSTANDARD LVCMOS33} [get_ports vga_hs]
#set_property -dict {PACKAGE_PIN B12 IOSTANDARD LVCMOS33} [get_ports vga_vs]

## Pmod Header JA
#set_property -dict {PACKAGE_PIN C4 IOSTANDARD LVCMOS33} [get_ports to_host]
#set_property -dict {PACKAGE_PIN D18 IOSTANDARD LVCMOS33} [get_ports uart_tx_busy];
#set_property -dict {PACKAGE_PIN D4 IOSTANDARD LVCMOS33} [get_ports from_host]
#set_property -dict {PACKAGE_PIN G17 IOSTANDARD LVCMOS33} [get_ports {JA[4]}];
#set_property -dict {PACKAGE_PIN D17 IOSTANDARD LVCMOS33} [get_ports {JA[7]}];
#set_property -dict {PACKAGE_PIN E17 IOSTANDARD LVCMOS33} [get_ports {JA[8]}];
#set_property -dict {PACKAGE_PIN F18 IOSTANDARD LVCMOS33} [get_ports {JA[9]}];
#set_property -dict {PACKAGE_PIN G18 IOSTANDARD LVCMOS33} [get_ports {JA[10]}];


#set_property C_CLK_INPUT_FREQ_HZ 300000000 [get_debug_cores dbg_hub]
#set_property C_ENABLE_CLK_DIVIDER false [get_debug_cores dbg_hub]
#set_property C_USER_SCAN_CHAIN 1 [get_debug_cores dbg_hub]
#connect_debug_port dbg_hub/clk [get_nets clk_IBUF_BUFG]