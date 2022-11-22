library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity gen_pixels is
	port(
		clk, reset: in std_logic;
		value_i: std_logic;
		ena: in std_logic;
		rgb_o : out std_logic_vector(2 downto 0)
	);
	
end gen_pixels;

architecture gen_pixels_arch of gen_pixels is
	signal rgb_reg: std_logic_vector(2 downto 0):= "000";
begin
	

	process(clk, reset)
	begin
		if reset = '1' then
			rgb_reg <= (others => '0');
        elsif rising_edge(clk) then
			if value_i = '1' then
				rgb_reg <= "111";
			else
				rgb_reg <= "000";
			end if;
		end if;
	end process;

	rgb_o <= rgb_reg when ena = '1' else "000";

end gen_pixels_arch;