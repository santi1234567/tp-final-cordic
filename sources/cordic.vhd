library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;
use IEEE.math_real.all;

entity cordic is
	generic(
		ETAPAS: natural := 7;
		N: 		natural := 10
	);
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
end;

architecture cordic_arq of cordic is

	component cordic_sub is
		generic(N: integer:= N);
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
	end component;
	type T_AUX_PIPELINE is array (0 to ETAPAS) of std_logic_vector(N-1 downto 0);

	signal aux_z, aux_y, aux_x: T_AUX_PIPELINE := (others =>(others => '0'));
	signal aux_z_scaled, aux_y_scaled, aux_x_scaled: std_logic_vector(2*N-1 downto 0) := (others => '0');
	signal g: signed(N-1 downto 0) := (others => '0');
	signal ena_tb	: std_logic := '1';
	type T_GAIN is array (0 to 7) of REAL;
	constant GAIN : T_GAIN :=
		(1.414213562,
		1.58113883,
		1.629800601,
		1.642484066,
		1.645688916,
		1.646492279,
		1.646693254,
		1.646743507);

begin

	aux_z(0) <= z_i;
	aux_y(0) <= y_i;
	aux_x(0) <= x_i;

	cordicgen: for i in 0 to ETAPAS-1 generate
			cordic_sub_inst: cordic_sub
				port map(
					clk_i 	=> clk_i,
					rst_i 	=> rst_i,
					ena_i 	=> ena_i,
					x_i	 	=> aux_x(i),
					y_i	 	=> aux_y(i),
					z_i	 	=> aux_z(i),
					x_o	 	=> aux_x(i+1),
					y_o	 	=> aux_y(i+1),
					z_o	 	=> aux_z(i+1)
				);
	end generate;
	g <= to_signed(integer(GAIN(ETAPAS)*real((2**N)-1)/real(2)/math_pi),N); -- uso valores entre 0 y 2pi.
	aux_z_scaled <= std_logic_vector(signed(aux_z(ETAPAS)) * g);
	--aux_y_scaled <= std_logic_vector(signed(aux_y(ETAPAS)) * g);
	--aux_x_scaled <= std_logic_vector(signed(aux_x(ETAPAS)) * g);
	--z_o <= aux_z_scaled(2*N-1 downto N);
	--y_o <= aux_y_scaled(2*N-1 downto N);
	--x_o <= aux_x_scaled(2*N-1 downto N);


end;