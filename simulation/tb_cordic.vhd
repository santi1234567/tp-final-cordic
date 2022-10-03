library IEEE;
use IEEE.std_logic_1164.all;
use ieee.numeric_std.all;
use IEEE.math_real.all;

entity cordic_tb is
end;

architecture cordic_tb_arq of cordic_tb is

	constant N: integer:=16;

	component cordic
		generic(ETAPAS: integer:= 7; N: integer:= N);
		port(
		z_i		: in std_logic_vector(N-1 downto 0);
	    y_i		: in std_logic_vector(N-1 downto 0);
	    x_i		: in std_logic_vector(N-1 downto 0);
	    z_o		: out std_logic_vector(N-1 downto 0);
	    y_o		: out std_logic_vector(N-1 downto 0);
	    x_o		: out std_logic_vector(N-1 downto 0);
		clk_i	: in std_logic;
		rst_i	: in std_logic;
		ena_i	: in std_logic
		);
	end component cordic;

	signal clk_tb	: std_logic := '0';
	signal rst_tb	: std_logic := '1';
	signal ena_tb	: std_logic := '1';
	signal x_i_tb	: std_logic_vector(N-1 downto 0) := (others => '0');
	signal y_i_tb	: std_logic_vector(N-1 downto 0) := (others => '0');
	signal z_i_tb	: std_logic_vector(N-1 downto 0) := (others => '0');
	signal x_o_tb	: std_logic_vector(N-1 downto 0);
	signal y_o_tb	: std_logic_vector(N-1 downto 0);
	signal z_o_tb	: std_logic_vector(N-1 downto 0);

begin

	clk_tb <= not clk_tb after 10 ns;
	rst_tb <= '0' after 50 ns;
	x_i_tb <= "0000000111011010" after 25 ns, "0001010111010010" after 45 ns, "0001001111011010" after 75 ns, "1011001111011010" after 105 ns, "0000001111011010" after 145 ns;
	y_i_tb <= "0000001111011010" after 25 ns, "1100000011011010" after 45 ns, "0100001010001010" after 75 ns, "0011000111011010" after 105 ns, "0000000011011011" after 145 ns;
	z_i_tb <= "0000000111011010" after 25 ns, "0100011111111011" after 45 ns, "0100100111011010" after 75 ns, "1001001101011010" after 105 ns, "0000001111011010" after 145 ns;
	ena_tb <= '0' after 135 ns;

	DUT: cordic
		port map(
			clk_i 	=> clk_tb,
			rst_i 	=> rst_tb,
			ena_i 	=> ena_tb,
			x_i	 	=> x_i_tb,
			y_i	 	=> y_i_tb,
			z_i	 	=> z_i_tb,
			x_o	 	=> x_o_tb,
			y_o	 	=> y_o_tb,
			z_o	 	=> z_o_tb
		);

end;
