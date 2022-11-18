library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;



entity rotator is
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
end;

architecture rotator_arq of rotator is

    -- 512 Steps for rotation variables. 

    constant ROTATION_STEPS: natural:= 512;

	component delay_N_cicles is
		generic(N: integer:=4; CICLES: integer:= 21);
		port(
			d_i		: in std_logic_vector(N-1 downto 0);
			clk_i	: in std_logic;
			rst_i	: in std_logic;
			ena_i	: in std_logic;
			q_o		: out std_logic_vector(N-1 downto 0)
		);
	end component;

    component cordic is
		generic(ETAPAS: integer := ETAPAS; N: integer:= N);
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

	type T_AUX_ROTATOR is array (0 to 2) of std_logic_vector(N-1 downto 0);
	signal aux_y, aux_x: T_AUX_ROTATOR := (others =>(others => '0'));

begin
	cordic_Rx: cordic generic map(ETAPAS, N) port map(alfa_i, z_i, y_i, open, aux_y(0), aux_x(0), clk_i, rst_i, '1');
	cordic_Ry: cordic generic map(ETAPAS, N) port map(beta_i, x_i, aux_y(0), open, aux_y(1), aux_x(1), clk_i, rst_i, '1');
	cordic_Rz: cordic generic map(ETAPAS, N) port map(gamma_i, aux_x(0), aux_y(1), open, aux_y(2), aux_x(2), clk_i, rst_i, '1');
	delay_8_CICLES: delay_N_cicles generic map(N, 8) port map(aux_x(1), clk_i, rst_i, '1', z_o);

	y_o <= aux_y(2);
	x_o <= aux_x(2);
end;
