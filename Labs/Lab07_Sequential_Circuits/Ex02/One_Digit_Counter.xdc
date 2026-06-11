## Configuration voltage
set_property CFGBVS VCCO [current_design]
set_property CONFIG_VOLTAGE 3.3 [current_design]

## Clock input - Nexys A7 100 MHz
set_property PACKAGE_PIN E3 [get_ports CLK]
set_property IOSTANDARD LVCMOS33 [get_ports CLK]
create_clock -period 10.000 -name sys_clk_pin -waveform {0.000 5.000} [get_ports CLK]

## Start/Stop input - BTNU
set_property PACKAGE_PIN M18 [get_ports STARTSTOP]
set_property IOSTANDARD LVCMOS33 [get_ports STARTSTOP]

## Clear input - BTNC
set_property PACKAGE_PIN N17 [get_ports CLEAR]
set_property IOSTANDARD LVCMOS33 [get_ports CLEAR]

## 7-segment cathodes
set_property PACKAGE_PIN T10 [get_ports {SEG[0]}]
set_property PACKAGE_PIN R10 [get_ports {SEG[1]}]
set_property PACKAGE_PIN K16 [get_ports {SEG[2]}]
set_property PACKAGE_PIN K13 [get_ports {SEG[3]}]
set_property PACKAGE_PIN P15 [get_ports {SEG[4]}]
set_property PACKAGE_PIN T11 [get_ports {SEG[5]}]
set_property PACKAGE_PIN L18 [get_ports {SEG[6]}]
set_property IOSTANDARD LVCMOS33 [get_ports {SEG[*]}]

## 7-segment anodes
set_property PACKAGE_PIN J17 [get_ports {AN[0]}]
set_property PACKAGE_PIN J18 [get_ports {AN[1]}]
set_property PACKAGE_PIN T9  [get_ports {AN[2]}]
set_property PACKAGE_PIN J14 [get_ports {AN[3]}]
set_property PACKAGE_PIN P14 [get_ports {AN[4]}]
set_property PACKAGE_PIN T14 [get_ports {AN[5]}]
set_property PACKAGE_PIN K2  [get_ports {AN[6]}]
set_property PACKAGE_PIN U13 [get_ports {AN[7]}]
set_property IOSTANDARD LVCMOS33 [get_ports {AN[*]}]