ghdl -a cordic.vhd tb_cordic.vhd
ghdl -s cordic.vhd tb_cordic.vhd
ghdl -e cordic_tb
ghdl -r cordic_tb --vcd=cordic.vcd --stop-time=1000ns --ieee-asserts=disable
gtkwave cordic.vcd
