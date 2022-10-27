library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

-- Recieves two points of data (N bits, signed) and indicates what pixel those data points correspond to 

entity data_processor is
	generic(
		N: 		natural := 10
	);
	port(
        data_y_i, data_z_i		: in std_logic_vector(N-1 downto 0);
		pixel_x_o, pixel_y_o	 : out std_logic_vector (9 downto 0):= (others => '0');
		clk_i	  				: in std_logic;
		rst_i 			  		: in std_logic;
		ena_i	  		  : in std_logic
	);
end;

architecture data_processor_arq of data_processor is
	signal x_o, y_o : std_logic_vector(10 downto 0);
	signal aux_x, aux_y :signed(N+10-1 downto 0);
begin
	process(clk_i, rst_i)
		constant cero: integer:= 0;

		constant fist_pixel_y: integer:= 80;
		constant center_pixel_y: integer:= 240;
		constant last_pixel_y: integer:= 400;
		
		constant offset_pixel: integer:= 160; -- Offset from center pixel 

		constant fist_pixel_z: integer:= 160;
		constant center_pixel_z: integer:= 320;
		constant last_pixel_z: integer:= 480;

    begin
		aux_x<=signed(data_y_i(N-1 downto 0))*to_signed(offset_pixel, 10);
		x_o <= std_logic_vector(to_signed(center_pixel_y,11)-aux_x(N+10-1 downto N-1)); 
		
		aux_y<=signed(data_z_i(N-1 downto 0))*to_signed(offset_pixel, 10);
		y_o <= std_logic_vector(to_signed(center_pixel_z,11)+aux_y(N+10-1 downto N-1)); 
		
		pixel_x_o <= x_o(9 downto 0);
		pixel_y_o <= y_o(9 downto 0);
		--report integer'image(to_integer(aux_x));
		--report integer'image(to_integer(aux_x(25 downto 15)));
		--report integer'image(to_integer(aux_y));
		--report integer'image(to_integer(aux_y(25 downto 15)));
		--report "Dato y: " & integer'image(to_integer(signed(data_y_i))) & ", Dato z: " & integer'image(to_integer(signed(data_z_i)));
		--report "Pixel x: " & integer'image(to_integer(signed(x_o))) & ", Pixel y: " & integer'image(to_integer(signed(y_o)));
		--report "---";
    end process;   
end;
