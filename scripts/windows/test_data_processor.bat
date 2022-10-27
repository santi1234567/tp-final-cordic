ghdl -a sources\data_processor.vhd simulation\tb_data_processor.vhd
ghdl -s sources\data_processor.vhd simulation\tb_data_processor.vhd
ghdl -e data_processor_tb
ghdl -r data_processor_tb --vcd=data_processor.vcd --stop-time=1000ns
gtkwave data_processor.vcd
