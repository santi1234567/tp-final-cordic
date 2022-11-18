ghdl -a sources\registro.vhd sources\delay_N_cicles.vhd simulation\tb_delay_N_cicles.vhd
ghdl -s sources\registro.vhd sources\delay_N_cicles.vhd simulation\tb_delay_N_cicles.vhd
ghdl -e delay_N_cicles_tb
ghdl -r delay_N_cicles_tb --vcd=delay_N_cicles.vcd --stop-time=1000ns
gtkwave delay_N_cicles.vcd
