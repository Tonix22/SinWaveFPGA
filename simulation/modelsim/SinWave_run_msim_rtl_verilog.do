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

add wave *
view structure
view signals
run -all
