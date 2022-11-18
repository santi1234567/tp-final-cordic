library IEEE;
use IEEE.std_logic_1164.all;
use ieee.numeric_std.all;

entity video_memory_controller is
	port(
		clk_pin	: in std_logic;
		rst_pin : in std_logic;
        rxd_pin : in std_logic;
        gamma_i		: in std_logic_vector(N-1 downto 0); -- rotation for z
        beta_i		: in std_logic_vector(N-1 downto 0); -- rotation for y
        alfa_i		: in std_logic_vector(N-1 downto 0)  -- rotation for x
    );
end;
	

architecture video_memory_controller_arq of video_memory_controller is

	constant N: integer:=16;

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

	component data_processor
		generic(N: integer:= N);
		port(
			data_y_i, data_z_i		: in std_logic_vector(N-1 downto 0);
			pixel_c_o : out std_logic_vector (18 downto 0);
			clk_i	  				: in std_logic;
			rst_i 			  		: in std_logic;
			ena_i	  		  : in std_logic
		);
	end component data_processor;

	component data_memory_controller is
		port(
            -- Write side inputs
            clk_pin:	in std_logic;      					-- Clock input (from pin)
            rst_pin: 	in std_logic;      					-- Active HIGH reset (from pin)
            rxd_pin: 	in std_logic;      					-- RS232 RXD pin - directly from pin
            addr_c_input : in std_logic_vector(14 downto 0);
            loading_data : out std_logic;
            data_o  : out std_logic_vector(15 downto 0)
		);
	end component;

    component block_RAM is
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
    end component;

    component rotator is
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
    end component;


    signal data_controller_loading: std_logic;
    signal rotating: std_logic:= '1';
    signal addr_c : std_logic_vector(14 downto 0) := (0 => '1', others => '0');
    signal addr_c_delayed : std_logic_vector(14 downto 0) := (0 => '1', others => '0');
    signal pixel_c: std_logic_vector(18 downto 0) := (others => '0');
    signal data, data_x, data_y, data_z, data_x_rot, data_y_rot, data_z_rot: std_logic_vector(15 downto 0);
    signal xyz_c : unsigned(1 downto 0) := 0;
    signal 3_cicle_counter : unsigned(1 downto 0) := 0;
    signal clk_cordic, rst_cordic, ena_x, ena_y, ena_z : std_logic := '0';
    signal waiting_25_cicles : unsigned(4 downto 0):= (others => '0'); -- rotator takes 25 cicles to start throwing outputs

    --signal we, high_low, data_read: std_logic:= '0';
begin

    rotator: rotator
        generic map(
            ETAPAS => 7;
            N      => N:
        );
        port(
            z_i		    => data_z,
            y_i		    => data_y,
            x_i		    => data_x,
            gamma_i		=> gamma_i, -- rotation for z
            beta_i		=> beta_i, -- rotation for y
            alfa_i		=> alfa_i, -- rotation for x
            z_o		    => data_z_rot,
            y_o		    => data_y_rot,
            x_o		    => data_x_rot,
            clk_i	    => clk_cordic,
            rst_i   	=> rst_cordic;
            ena_i	    => '1'
        );

    video_memory: block_RAM
        generic map(
            MEM_DEPTH => 10,
            MEM_WIDTH => 640
        )
        port map(
            clk => clk_pin,
            addr => pixel_c,
            we => we,
            data_i => '1',
            data_o => open
        );

	U0: data_memory_controller
		port map(
			clk_pin => clk_pin,  	-- Clock input (from pin)
			rst_pin => rst_pin,  	-- Active HIGH reset (from pin)
			rxd_pin => rxd_pin,--rxd_pin,  	-- RS232 RXD pin - directly from pin
            addr_c_input => addr_c,
            loading_data => data_controller_loading,
            data_o  => data
		);
    regZ: registro generic map(N) port map(data, clk_i, '0', ena_z, data_z);
    regY: registro generic map(N) port map(data, clk_i, '0', ena_y, data_y);
    regX: registro generic map(N) port map(data, clk_i, '0', ena_x, data_x);

	DP: data_processor
		port map(
			clk_i 	=> clk_pin,
			rst_i 	=> rst_pin,
			ena_i 	=> '1',
			data_y_i	 	=> data_y,
			data_z_i		=> data_z,
			pixel_c_o => pixel_c
		);

    process(clk_pin)
    begin
        if rising_edge(clk_pin) then
            if rotating = '1' then
                if xyz_c = 0 then -- x
                    ena_x <= '1';
                    ena_y <= '0';
                    ena_z <= '0';
                    xyz_c <= xyz_c + 1;
                else if xyz_c = 1 then -- y
                    ena_x <= '0';
                    ena_y <= '1';
                    ena_z <= '0';
                    xyz_c <= xyz_c + 1;        
                else -- z
                    ena_x <= '0';
                    ena_y <= '0';
                    ena_z <= '1';
                    xyz_c <= xyz_c + 2;
                    if waiting_25_cicles < 25 then
                        waiting_25_cicles <= waiting_25_cicles + 1;
                    end if;
                end if;
                if unsigned(addr_c) = 2**15-1 then
                    rotating <= '0';
                    addr_c <= (0 => '1', others => '0');
                else
                    addr_c <= addr_c +1;
                end if;
            end if;

            if 3_cicle_counter = 2 then
                3_cicle_counter <= 3_cicle_counter + 2;
                clk_cordic <= '1';
            else
                3_cicle_counter <= 3_cicle_counter + 1;
                clk_cordic <= '0';            
            end if;


        end if;
    end process;

    process(clk_cordic)
    begin
        if rising_edge(clk_cordic) then
            if waiting_25_cicles = 25 then
                if unsigned(addr_c_delayed) = 2**15-1 then
                    waiting_25_cicles <= 0;
                    addr_c_delayed <= (others => '0');
                    we <= '0';
                else
                    addr_c_delayed <= addr_c_delayed + 1;
                end if;
                we <= '1';
            end if;
        end if;
    end process;
end;
