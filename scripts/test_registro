ghdl -a registro.vhd tb_registro.vhd
ghdl -s registro.vhd tb_registro.vhd
ghdl -e registro_tb
ghdl -r registro_tb --vcd=registro.vcd --stop-time=1000ns
gtkwave registro.vcd
