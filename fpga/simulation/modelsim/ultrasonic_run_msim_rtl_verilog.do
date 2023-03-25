transcript on
if {[file exists rtl_work]} {
	vdel -lib rtl_work -all
}
vlib rtl_work
vmap work rtl_work

vlog -sv -work work +incdir+C:/Users/roger/Desktop/projects/ultrasonic/fpga {C:/Users/roger/Desktop/projects/ultrasonic/fpga/phase_generator.v}
vlog -sv -work work +incdir+C:/Users/roger/Desktop/projects/ultrasonic/fpga {C:/Users/roger/Desktop/projects/ultrasonic/fpga/clock_divider.v}
vlog -sv -work work +incdir+C:/Users/roger/Desktop/projects/ultrasonic/fpga {C:/Users/roger/Desktop/projects/ultrasonic/fpga/spi_slave.v}
vlog -sv -work work +incdir+C:/Users/roger/Desktop/projects/ultrasonic/fpga {C:/Users/roger/Desktop/projects/ultrasonic/fpga/ultrasonic.v}

