library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity data_processor_tb is
end;

architecture data_processor_tb_arq of data_processor_tb is

	constant N: integer:=16;

	component data_processor
		generic(N: integer:= N);
		port(
			data_y_i, data_z_i		: in std_logic_vector(N-1 downto 0);
			pixel_c_o: out std_logic_vector (18 downto 0);
			--pixel_x_o, pixel_y_o	 : out std_logic_vector (9 downto 0);
			clk_i	  				: in std_logic;
			rst_i 			  		: in std_logic;
			ena_i	  		  : in std_logic
		);
	end component data_processor;

	signal clk_tb	: std_logic := '0';
	signal rst_tb	: std_logic := '1';
	signal ena_tb: std_logic := '1';
	signal data_y_tb, data_z_tb	: std_logic_vector(N-1 downto 0);
	--signal pixel_x_tb, pixel_y_tb	 : std_logic_vector (9 downto 0);
	signal pixel_c_tb: std_logic_vector (18 downto 0);


begin

	clk_tb <= not clk_tb after 10 ns;
	rst_tb <= '0' after 50 ns;
	data_y_tb <= std_logic_vector(to_signed(0,N)) after 25 ns, std_logic_vector(to_signed((2**(N-1)-1)/2,N)) after 100 ns, std_logic_vector(to_signed(2**(N-1),N)) after 200 ns;
	data_z_tb <= std_logic_vector(to_signed(0,N)) after 25 ns, std_logic_vector(to_signed(2**(N-1)-1,N)) after 100 ns, std_logic_vector(to_signed(2**(N-1),N)) after 200 ns;
	ena_tb <= '0' after 135 ns;
	
	DUT: data_processor
		port map(
			clk_i 	=> clk_tb,
			rst_i 	=> rst_tb,
			ena_i 	=> ena_tb,
			data_y_i	 	=> data_y_tb,
			data_z_i		=> data_z_tb,
			pixel_c_o => pixel_c_tb
			--pixel_x_o => pixel_x_tb,
			--pixel_y_o => pixel_y_tb
		);

end;
