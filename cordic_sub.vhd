library IEEE;
use IEEE.std_logic_1164.all;

entity cordic_sub is
  -- N tamanio de entradas/salidas, "ETAPA" numero de etapa (define la cantidad de shifts y la constante a utilizar)
	generic(N: integer:=4, ETAPA: integer);
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
begin
  -- REVISAR EL TIPO. DEBERIA SER PUNTO FIJO O FLOTANTE
  type T_ROTACION is array (0 to 3)
      of bit_vector(7 downto 0);
  constant ROTACION : T_ROTACION :=
          ("0.78539816",
           "0.46364761",
           "0.24497866",
         "0.12435499",
         "0.06241881",
         "0.03123983");
  sumador_z: entity work.sumador
    port map(
      A 	=> ROTACION(ETAPA),
      B 	=> z_i,
      Cin 	=> 0,
      Sal 	=> z_o,
      Cout	=> open
    );
  process
    -- para tomar como referencia
    if rst_i = '1' then
			q_o <= (others => '0');
		elsif clk_i = '1' and clk_i'event then
			if ena_i = '1' then
				q_o <= d_i
			end if;
		end if;
	end process;
end;
