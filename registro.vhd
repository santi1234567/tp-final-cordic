library IEEE;
use IEEE.std_logic_1164.all;

entity registro is
	generic(N: integer:=4);
	port(
		d_i		: in std_logic_vector(N-1 downto 0);
		clk_i	: in std_logic;
		rst_i	: in std_logic;
		ena_i	: in std_logic;
		q_o		: out std_logic_vector(N-1 downto 0)
	);
end;

architecture registro_arq of registro is
begin
	process(clk_i, rst_i)
	begin
		if rst_i = '1' then
			q_o <= (others => '0');
		elsif clk_i = '1' and clk_i'event then
			if ena_i = '1' then
				q_o <= d_i
			end if;
		end if;
	end process;
end;
