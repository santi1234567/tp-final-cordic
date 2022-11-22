library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity top is
	port(
		clk_pin, rst_pin: in std_logic;
        btn_x, btn_y, btn_z: in std_logic;
        rxd_pin : in std_logic;
		hs_o , vs_o : out std_logic;
		rgb_o : out std_logic_vector(2 downto 0)
    );

end top;

architecture top_arch of top is
	signal pixel_c: std_logic_vector(19 downto 0);
    signal value: std_logic;
    signal gamma, beta, alfa: std_logic_vector(15 downto 0);
    signal rot_x_c, rot_y_c, rot_z_c: std_logic_vector(21 downto 0);
    signal rot_x, rot_y, rot_z: std_logic_vector(8 downto 0);
begin

	vga_ctrl_unit: entity work.vga_ctrl
		port map(
			clk_i 	=> clk_pin,
			rst_i 	=> rst_pin,
			hs_o 	=> hs_o,
			vs_o 	=> vs_o,
            pixel_c_o => pixel_c,
            value_i => value,
			rgb_o => rgb_o
		);

    video_memory_controller_unit: entity work.video_memory_controller
        port map (
            clk_pin     => 	clk_pin,
            rst_pin     => rst_pin,
            rxd_pin     => rxd_pin,
            pixel_c_i   => pixel_c,
            value_o     => value,
            gamma_i		=> gamma, -- rotation for z
            beta_i		=> beta, -- rotation for y
            alfa_i		=> alfa  -- rotation for x
        );

    gamma(15 downto 7) <= rot_z;
    gamma(6 downto 0) <= (others => '0');
    beta(15 downto 7) <= rot_y;
    beta(6 downto 0) <= (others => '0');
    alfa(15 downto 7) <= rot_x;
    alfa(6 downto 0) <= (others => '0');

    identifier : process( clk_pin )
    begin
        if rising_edge(clk_pin) then
            if btn_x = '1' then
                if unsigned(rot_x_c) < 2500000 then
                    rot_x_c <= std_logic_vector(unsigned(rot_x_c) +1);
                else
                    rot_x_c <= (others => '0');
                    rot_x <= std_logic_vector(unsigned(rot_x) +1);                    
                end if;
            end if;
            if btn_y = '1' then
                if unsigned(rot_y_c) < 2500000 then
                    rot_y_c <= std_logic_vector(unsigned(rot_y_c) +1);
                else
                    rot_y_c <= (others => '0');
                    rot_y <= std_logic_vector(unsigned(rot_y) +1);                    
                end if;
            end if;
            if btn_z = '1' then
                if unsigned(rot_z_c) < 2500000 then
                    rot_z_c <= std_logic_vector(unsigned(rot_z_c) +1);
                else
                    rot_z_c <= (others => '0');
                    rot_z <= std_logic_vector(unsigned(rot_z) +1);                    
                end if;
            end if;
        end if;
    end process; -- identifier

end top_arch;
