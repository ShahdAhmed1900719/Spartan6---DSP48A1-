vlib work
vlog mux_3to1.v reg_mux.v spatran6.v
vsim -voptargs=+acc work.spartan6
add wave *
run -all
