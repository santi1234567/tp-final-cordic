ghdl -a sources\registro.vhd sources\cordic_sub.vhd sources\cordic_pre_processor.vhd sources\cordic.vhd simulation\tb_cordic.vhd
ghdl -s sources\registro.vhd sources\cordic_sub.vhd sources\cordic_pre_processor.vhd sources\cordic.vhd simulation\tb_cordic.vhd
ghdl -e cordic_tb
ghdl -r cordic_tb --vcd=cordic.vcd --stop-time=700ns --ieee-asserts=disable
gtkwave cordic.vcd
