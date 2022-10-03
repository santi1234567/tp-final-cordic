ghdl -a sources\registro.vhd simulation\tb_registro.vhd
ghdl -s sources\registro.vhd simulation\tb_registro.vhd
ghdl -e registro_tb
ghdl -r registro_tb --vcd=registro.vcd --stop-time=1000ns
gtkwave registro.vcd
