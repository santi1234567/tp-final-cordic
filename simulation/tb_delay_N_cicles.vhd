library IEEE;
use IEEE.std_logic_1164.all;

entity delay_N_cicles_tb is
end;

architecture delay_N_cicles_tb_arq of delay_N_cicles_tb is

	constant N: integer:=10;

	component delay_N_cicles
		generic(N: integer:= N; CICLES: integer:= 21);
		port(
			d_i		: in std_logic_vector(N-1 downto 0);
			clk_i	: in std_logic;
			rst_i	: in std_logic;
			ena_i	: in std_logic;
			q_o		: out std_logic_vector(N-1 downto 0)
		);
	end component delay_N_cicles;

	signal clk_tb	: std_logic := '0';
	signal rst_tb	: std_logic := '0';
	signal ena_tb: std_logic := '1';
	signal d_tb	: std_logic_vector(N-1 downto 0) := (others => '0');
	signal q_tb: std_logic_vector(N-1 downto 0);

begin

	clk_tb <= not clk_tb after 10 ns;
	d_tb <= (others => '1') after 25 ns, (others => '0') after 45 ns, (others => '1') after 75 ns, (others => '0') after 105 ns, (others => '1') after 145 ns;
	
	DUT: delay_N_cicles
		generic map(N, 25)
		port map(
			clk_i 	=> clk_tb,
			rst_i 	=> rst_tb,
			ena_i 	=> ena_tb,
			d_i	 	=> d_tb,
			q_o		=> q_tb
		);

end;
