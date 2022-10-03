ghdl -a sources\registro.vhd sources\cordic_sub.vhd sources\cordic.vhd simulation\tb_cordic.vhd
ghdl -s sources\registro.vhd sources\cordic_sub.vhd sources\cordic.vhd simulation\tb_cordic.vhd
ghdl -e cordic_tb
ghdl -r cordic_tb --vcd=cordic.vcd --stop-time=500ns --ieee-asserts=disable
gtkwave cordic.vcd
