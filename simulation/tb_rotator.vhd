library IEEE;
use IEEE.std_logic_1164.all;
use ieee.numeric_std.all;
use IEEE.math_real.all;

entity rotator_tb is
end;

architecture rotator_tb_arq of rotator_tb is

	constant N: integer:=16;

	component rotator
		generic(
			ETAPAS: natural := 7;
			N: 		natural := 10
		);
		port(
			z_i		    : in std_logic_vector(N-1 downto 0);
			y_i		    : in std_logic_vector(N-1 downto 0);
			x_i		    : in std_logic_vector(N-1 downto 0);
			gamma_i		: in std_logic_vector(N-1 downto 0); -- rotation for z
			beta_i		: in std_logic_vector(N-1 downto 0); -- rotation for y
			alfa_i		: in std_logic_vector(N-1 downto 0); -- rotation for x
			z_o		    : out std_logic_vector(N-1 downto 0);
			y_o		    : out std_logic_vector(N-1 downto 0);
			x_o		    : out std_logic_vector(N-1 downto 0);
			clk_i	    : in std_logic;
			rst_i   	: in std_logic;
			ena_i	    : in std_logic
		);
	end component rotator;

	signal clk_tb	: std_logic := '0';
	signal rst_tb	: std_logic := '0';
	signal ena_tb	: std_logic := '1';
	signal x_i_tb	: std_logic_vector(N-1 downto 0) := (others => '0');
	signal y_i_tb	: std_logic_vector(N-1 downto 0) := (others => '0');
	signal z_i_tb	: std_logic_vector(N-1 downto 0) := (others => '0');
	signal x_o_tb	: std_logic_vector(N-1 downto 0);
	signal y_o_tb	: std_logic_vector(N-1 downto 0);
	signal z_o_tb	: std_logic_vector(N-1 downto 0);
	signal gamma_i_tb : std_logic_vector(N-1 downto 0); -- rotation for z
	signal beta_i_tb : std_logic_vector(N-1 downto 0); -- rotation for z
	signal alfa_i_tb : std_logic_vector(N-1 downto 0); -- rotation for z

begin

	clk_tb <= not clk_tb after 10 ns;
	x_i_tb <= "0000000111011010" after 25 ns, "0001010111010010" after 45 ns, "1001001111011010" after 75 ns, "1011001111011010" after 105 ns, "0000001111011010" after 145 ns, std_logic_vector(to_signed(8191,N)) after 160 ns, std_logic_vector(to_signed(-5082,N)) after 190 ns, std_logic_vector(to_signed(27686,N)) after 220 ns;
	y_i_tb <= "0000001111011010" after 25 ns, "1100000011011010" after 45 ns, "0100001010001010" after 75 ns, "0011000111011010" after 105 ns, "0000000011011011" after 145 ns, std_logic_vector(to_signed(8191,N)) after 160 ns, std_logic_vector(to_signed(17034,N)) after 190 ns, std_logic_vector(to_signed(17034,N)) after 220 ns;
	z_i_tb <= "0000000111011010" after 25 ns, "0100011111111011" after 45 ns, "0100100111011010" after 75 ns, "0001001101011010" after 105 ns, "0000001111011010" after 145 ns, std_logic_vector(to_signed(-8191,N)) after 160 ns, std_logic_vector(to_signed(18906,N)) after 190 ns, std_logic_vector(to_signed(-13861,N)) after 220 ns;
	gamma_i_tb <= (others => '0') after 50 ns;
	beta_i_tb <= (others => '0') after 50 ns;
	alfa_i_tb <= (others => '0') after 50 ns;

	DUT: rotator
		generic map(
			ETAPAS => 7,
			N => N
		)
		port map(
			z_i	 	=> z_i_tb,
			y_i	 	=> y_i_tb,
			x_i	 	=> x_i_tb,
			gamma_i	=> gamma_i_tb, -- rotation for z
			beta_i	=> beta_i_tb, -- rotation for y
			alfa_i	=> alfa_i_tb, -- rotation for x
			z_o	 	=> z_o_tb,
			y_o	 	=> y_o_tb,
			x_o	 	=> x_o_tb,
			clk_i 	=> clk_tb,
			rst_i 	=> rst_tb,
			ena_i 	=> ena_tb
		);

end;
