library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;
use IEEE.math_real.all;

entity delay_N_cicles is
	generic(N: integer:=4; CICLES: integer:= 21);
	port(
		d_i		: in std_logic_vector(N-1 downto 0);
		clk_i	: in std_logic;
		rst_i	: in std_logic;
		ena_i	: in std_logic;
		q_o		: out std_logic_vector(N-1 downto 0)
	);
end;

architecture delay_N_cicles_arq of delay_N_cicles is


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


	type T_AUX_PIPELINE is array (0 to CICLES+1) of std_logic_vector(N-1 downto 0);
	signal aux: T_AUX_PIPELINE := (others =>(others => '0'));
begin
    aux(0) <= d_i;

	delay_N_ciclesgen: for i in 0 to CICLES generate
		register_inst: registro
			generic map(
				N => N
			)
			port map(
                d_i => aux(i),
				clk_i 	=> clk_i,
				rst_i 	=> rst_i,
				ena_i 	=> ena_i,
                q_o => aux(i+1)
			);
	end generate;
	q_o <= aux(CICLES+1);
end;
