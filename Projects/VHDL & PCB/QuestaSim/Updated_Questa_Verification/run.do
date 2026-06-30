# QuestaSim / ModelSim TCL script for RSU controller waveform
# Put this file in the same folder as:
#   rsu_controller.vhd
#   tb_rsu_controller.vhd
# Then in Questa Transcript run:  do run.do

transcript on

# Clean and create working library
if {[file exists work]} {
    vdel -lib work -all
}
vlib work
vmap work work

# Compile VHDL files
vcom -2008 rsu_controller.vhd
vcom -2008 tb_rsu_controller.vhd

# Start simulation with full signal visibility, so internal dut/state and dut/timer are visible
vsim -voptargs=+acc work.tb_rsu_controller

# Wave window setup
quietly WaveActivateNextPane {} 0
delete wave *

add wave -noupdate -divider {SCENARIO}
add wave -noupdate -radix unsigned /tb_rsu_controller/scenario_id

add wave -noupdate -divider {CLOCK RESET TICK}
add wave -noupdate /tb_rsu_controller/clk
add wave -noupdate /tb_rsu_controller/reset
add wave -noupdate /tb_rsu_controller/tick_1s

add wave -noupdate -divider {REQUEST INPUTS}
add wave -noupdate /tb_rsu_controller/N_req
add wave -noupdate /tb_rsu_controller/S_req
add wave -noupdate /tb_rsu_controller/E_req
add wave -noupdate /tb_rsu_controller/W_req

add wave -noupdate -divider {GRANT OUTPUTS}
add wave -noupdate /tb_rsu_controller/N_grant
add wave -noupdate /tb_rsu_controller/S_grant
add wave -noupdate /tb_rsu_controller/E_grant
add wave -noupdate /tb_rsu_controller/W_grant

add wave -noupdate -divider {ROAD SUMMARY}
add wave -noupdate /tb_rsu_controller/main_req_wave
add wave -noupdate /tb_rsu_controller/side_req_wave
add wave -noupdate /tb_rsu_controller/main_grant_wave
add wave -noupdate /tb_rsu_controller/side_grant_wave
add wave -noupdate /tb_rsu_controller/conflict_wave

add wave -noupdate -divider {CONTROLLER OUTPUT STATUS}
add wave -noupdate -radix binary   /tb_rsu_controller/road_code
add wave -noupdate -radix unsigned /tb_rsu_controller/countdown

add wave -noupdate -divider {INTERNAL FSM}
add wave -noupdate /tb_rsu_controller/dut/state
add wave -noupdate -radix unsigned /tb_rsu_controller/dut/timer

TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {0 ns} 0}
configure wave -namecolwidth 330
configure wave -valuecolwidth 100
configure wave -justifyvalue left
configure wave -signalnamewidth 1
configure wave -timelineunits ns
update

run 2496 ns
wave zoom range 0 ns 2500 ns
