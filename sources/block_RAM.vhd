-------------------------------------------------------
--
-- Implementacion de una block RAM single port
--
-------------------------------------------------------

library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity block_RAM is
	generic(
		-- Cantidad de bits que conforman la direccion 
		MEM_DEPTH: integer := 15;
		-- Cantidad de bits del dato
		MEM_WIDTH: integer := 8
	);
	port(
		clk : in std_logic;
		addr : in std_logic_vector(MEM_DEPTH-1 downto 0);
		we : in std_logic;
		data_i : in std_logic_vector(MEM_WIDTH-1 downto 0);
		data_o : out std_logic_vector(MEM_WIDTH-1 downto 0)
	);
	 
end block_RAM;

architecture block_RAM_arq of block_RAM is

	-- Declaracion de un tipo arreglo de N elementos de 8 bits
	type ram_t is array (0 to 2**MEM_DEPTH-1) of std_logic_vector(MEM_WIDTH-1 downto 0);
	
	-- Declaracion de la memoria e inicializacion
	 signal RAM : ram_t := (others => (others => '0'));

	-- Definicion de atributos para forzar la utilizacion de una BRAM (block RAM)
	attribute ram_style: string;
	attribute ram_style of ram : signal is "block";
	-- attribute ram_style of ram : signal is "distributed";

begin

	-- Proceso de lectura y escritura. Esta ultima posee una entrada de habilitacion
	process(clk)
	begin
		if(rising_edge(clk)) then
			if we = '1' then
				ram(to_integer(unsigned(addr))) <= data_i;
			end if;
			data_o <= ram(to_integer(unsigned(addr)));
		end if;
	end process;

end block_RAM_arq;