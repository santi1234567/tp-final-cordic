ghdl -a sources\registro.vhd sources\cordic_sub.vhd sources\cordic_pre_processor.vhd sources\cordic.vhd sources\delay_N_cicles.vhd sources\rotator.vhd simulation\tb_rotator.vhd
ghdl -s sources\registro.vhd sources\cordic_sub.vhd sources\cordic_pre_processor.vhd sources\cordic.vhd sources\delay_N_cicles.vhd sources\rotator.vhd simulation\tb_rotator.vhd
ghdl -e rotator_tb
ghdl -r rotator_tb --vcd=rotator.vcd --stop-time=1300ns --ieee-asserts=disable
gtkwave rotator.vcd
