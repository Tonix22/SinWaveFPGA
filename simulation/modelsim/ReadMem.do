transcript on
if {[file exists rtl_work]} {
	vdel -lib rtl_work -all
}
vlib rtl_work
vmap work rtl_work

vlog -vlog01compat -work work +incdir+/home/tonix/Documents/QuartusCinves/SinWaveProject {/home/tonix/Documents/QuartusCinves/SinWaveProject/config.v}
vlog -vlog01compat -work work +incdir+/home/tonix/Documents/QuartusCinves/SinWaveProject/Prescaler {/home/tonix/Documents/QuartusCinves/SinWaveProject/Prescaler/Prescaler.v}
vlog -vlog01compat -work work +incdir+/home/tonix/Documents/QuartusCinves/SinWaveProject/DDS {/home/tonix/Documents/QuartusCinves/SinWaveProject/DDS/FSM.v}
vlog -vlog01compat -work work +incdir+/home/tonix/Documents/QuartusCinves/SinWaveProject/MemoryDriver {/home/tonix/Documents/QuartusCinves/SinWaveProject/MemoryDriver/Memory.v}
vlog -vlog01compat -work work +incdir+/home/tonix/Documents/QuartusCinves/SinWaveProject/DDS {/home/tonix/Documents/QuartusCinves/SinWaveProject/DDS/DDS.v}

vlog -vlog01compat -work work +incdir+/home/tonix/Documents/QuartusCinves/SinWaveProject/test {/home/tonix/Documents/QuartusCinves/SinWaveProject/test/MemoryRead_tb.v}

vsim -t 1ps -L altera_ver -L lpm_ver -L sgate_ver -L altera_mf_ver -L altera_lnsim_ver -L cyclonev_ver -L cyclonev_hssi_ver -L cyclonev_pcie_hip_ver -L rtl_work -L work -voptargs="+acc"  MemoryRead_tb


radix define States {
	2'b00 "S0" -color cyan,
	2'b01 "S1" -color yellow,
	2'b10 "S2" -color "spring green",
	2'b11 "S3" ,
	-default hex
	-defaultcolor black
}

add wave -position end sim:/MemoryRead_tb/src_clk
add wave -position end sim:/MemoryRead_tb/set_phase

#add wave -position end sim:/MemoryRead_tb/phase 
#add wave -radix unsigned -position end sim:/MemoryRead_tb/data_wr 
#add wave -radix unsigned -position end sim:/MemoryRead_tb/addr_wr 
#add wave -position end sim:/MemoryRead_tb/sinwave

add wave -position end sim:/MemoryRead_tb/we

add wave -position end sim:/MemoryRead_tb/dds_dut/tic_tac
add wave -radix unsigned -position end sim:/MemoryRead_tb/dds_dut/memdir
add wave -radix unsigned -position end sim:/MemoryRead_tb/dds_dut/huffman
add wave -radix unsigned -position end sim:/MemoryRead_tb/dds_dut/addr_rd

add wave -radix unsigned -position end sim:/MemoryRead_tb/dds_dut/phase_indx
add wave -position end sim:/MemoryRead_tb/dds_dut/wave_ena

add wave -position end sim:/MemoryRead_tb/dds_dut/fts

add wave -radix States -position end sim:/MemoryRead_tb/dds_dut/fsm/state

add wave -position end sim:/MemoryRead_tb/dds_dut/read_mem

add wave -radix unsigned -position end  sim:/MemoryRead_tb/dds_dut/mem/q

add wave -radix unsigned -format analog-step -min 0 -max 254 -height 84 -position end sim:/MemoryRead_tb/dds_dut/sinwave

add wave -position end sim:/MemoryRead_tb/dds_dut/trigger

add wave -position end sim:/MemoryRead_tb/dds_dut/phase



view structure
view signals
run -all
