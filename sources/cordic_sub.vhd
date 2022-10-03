library IEEE;
use IEEE.std_logic_1164.all;
use ieee.numeric_std.all;
use IEEE.math_real.all;

entity cordic_sub is
  -- N tamanio de entradas/salidas, "ETAPA" numero de etapa (define la cantidad de shifts y la constante a utilizar)
	generic(N: integer:=4; ETAPA: integer:= 0);
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

architecture cordic_sub_arq of cordic_sub is

	component registro is
		generic(N: integer:=N);
		port(
			d_i: in std_logic_vector(N-1 downto 0);
			clk_i: in std_logic;
			rst_i: in std_logic;
			ena_i: in std_logic;
			q_o: out std_logic_vector(N-1 downto 0)
		);
	end component;

	signal res_z, res_y, res_x: std_logic_vector(N-1 downto 0);
	signal rot: signed(N-1 downto 0);
	type T_ROTACION is array (0 to 7) of REAL;
	constant ROTACION : T_ROTACION :=
		(0.78539816,
		0.46364761,
		0.24497866,
		0.12435499,
		0.06241881,
		0.03123983,
		0.01562373,
		0.00781234);

begin
	regZ: registro generic map(N) port map(res_z, clk_i, '0', '1', z_o);
	regY: registro generic map(N) port map(res_y, clk_i, '0', '1', y_o);
	regX: registro generic map(N) port map(res_x, clk_i, '0', '1', x_o);
	process(clk_i, rst_i)
		constant cero: integer range 0 to N-1:= 0;
	begin
		rot <= to_signed(integer(ROTACION(ETAPA)*real((2**N)-1)/real(2)/math_pi),N); -- uso valores entre 0 y 2pi.
		if signed(z_i) < cero then
			res_z <= std_logic_vector(signed(z_i) + rot);
			res_y <= std_logic_vector(signed(y_i) - shift_right(signed(x_i), ETAPA)); -- x_i shift ETAPA cantidad de veces a la derecha
			res_x <= std_logic_vector(signed(x_i) + shift_right(signed(y_i), ETAPA)); -- y_i shift ETAPA cantidad de veces a la derecha
		else
			res_z <= std_logic_vector(signed(z_i) - rot);
			res_y <= std_logic_vector(signed(y_i) + shift_right(signed(x_i), ETAPA)); -- x_i shift ETAPA cantidad de veces a la derecha
			res_x <= std_logic_vector(signed(x_i) - shift_right(signed(y_i), ETAPA)); -- y_i shift ETAPA cantidad de veces a la derecha
		end if;
		--report "Rotar: " & integer'image(to_integer(rot));--rot <= std_logic_vector(to_signed(natural(ROTACION(ETAPA)),N-1));
		--report "Valor z_i: " & integer'image(to_integer(signed(z_i)));
		--report "Resultado: " & integer'image(to_integer(signed(res_z)));
		--report "---";
	end process;
end cordic_sub_arq;
