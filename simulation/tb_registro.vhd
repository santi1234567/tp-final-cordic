library IEEE;
use IEEE.std_logic_1164.all;

entity registro_tb is
end;

architecture registro_tb_arq of registro_tb is

	constant N: integer:=10;

	component registro
		generic(N: integer:= N);
		port(
			d_i		: in std_logic_vector(N-1 downto 0);
			clk_i	: in std_logic;
			rst_i	: in std_logic;
			ena_i	: in std_logic;
			q_o		: out std_logic_vector(N-1 downto 0)
		);
	end component registro;

	signal clk_tb	: std_logic := '0';
	signal rst_tb	: std_logic := '1';
	signal ena_tb: std_logic := '1';
	signal d_tb	: std_logic_vector(N-1 downto 0) := (others => '0');
	signal q_tb: std_logic_vector(N-1 downto 0);

begin

	clk_tb <= not clk_tb after 10 ns;
	rst_tb <= '0' after 50 ns;
	d_tb <= (others => '1') after 25 ns, (others => '0') after 45 ns, (others => '1') after 75 ns, (others => '0') after 105 ns, (others => '1') after 145 ns;
	ena_tb <= '0' after 135 ns;
	
	DUT: registro
		port map(
			clk_i 	=> clk_tb,
			rst_i 	=> rst_tb,
			ena_i 	=> ena_tb,
			d_i	 	=> d_tb,
			q_o		=> q_tb
		);

end;
