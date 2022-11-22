library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity vga_ctrl is
	port(
		clk_i, rst_i: in std_logic;
		hs_o , vs_o : out std_logic;
		pixel_c_o: out std_logic_vector(19 downto 0);
		value_i: in std_logic;
		rgb_o : out std_logic_vector(2 downto 0)
    );

end vga_ctrl;

architecture vga_ctrl_arch of vga_ctrl is

	signal pixel_x, pixel_y: std_logic_vector(9 downto 0);
	signal video_on: std_logic;

begin
	pixel_c_o <= std_logic_vector(unsigned(pixel_y)*to_unsigned(640,10) + unsigned(pixel_x)); -- bajar a 19 pixeles

	-- instanciacion del controlador VGA
	vga_sync_unit: entity work.vga_sync
		port map(
			clk 	=> clk_i,
			rst 	=> rst_i,
			hsync 	=> hs_o,
			vsync 	=> vs_o,
			vidon	=> video_on,
			p_tick 	=> open,
			pixel_x => pixel_x,
			pixel_y => pixel_y
		);

	pixeles: entity work.gen_pixels
		port map(
			clk		=> clk_i,
			reset	=> rst_i,
			value_i	=> value_i,
			ena		=> video_on,
			rgb_o	=> rgb_o		-- 101	-->  111 000 11
		);

end vga_ctrl_arch;
