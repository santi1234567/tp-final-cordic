ghdl -a sources\registro.vhd sources\cordic_sub.vhd simulation\tb_cordic_sub.vhd
ghdl -s sources\registro.vhd sources\cordic_sub.vhd simulation\tb_cordic_sub.vhd
ghdl -e cordic_sub_tb
ghdl -r cordic_sub_tb --vcd=cordic_sub.vcd --stop-time=300ns
gtkwave cordic_sub.vcd
