library IEEE;
use IEEE.std_logic_1164.all;
use ieee.numeric_std.all;

entity data_memory_controller_vio is
	port(
		clk_pin	: in std_logic;
		rst_pin : in std_logic;
        rxd_pin : in std_logic
    );
end;
	

architecture data_memory_controller_vio_arq of data_memory_controller_vio is

	component uart_top is
		generic(
			BAUD_RATE: integer := 115200;   
			CLOCK_RATE: integer := 50E6
		);
		port(
            -- Write side inputs
            clk_pin:	in std_logic;      					-- Clock input (from pin)
            rst_pin: 	in std_logic;      					-- Active HIGH reset (from pin)
            rxd_pin: 	in std_logic;      					-- RS232 RXD pin - directly from pin
            rx_data_rdy: 	out std_logic;  				-- Ready signal for rx_data
            rx_data: 		out std_logic_vector(7 downto 0)	-- 8 bit data output
		);
	end component;
    COMPONENT vio_1
      PORT (
        clk : IN STD_LOGIC;
        probe_in0 : IN STD_LOGIC_VECTOR(28 DOWNTO 0);
        probe_in1 : IN STD_LOGIC_VECTOR(14 DOWNTO 0);
        probe_in2 : IN STD_LOGIC_VECTOR(15 DOWNTO 0);
        probe_out0 : OUT STD_LOGIC_VECTOR(14 DOWNTO 0)
      );
    END COMPONENT;
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
    signal addr_c : std_logic_vector(14 downto 0) := (others => '0');
    signal c: std_logic_vector(28 downto 0) := (others => '0');
    signal data_probe : std_logic_vector(15 downto 0);
    signal active: std_logic:= '1';
    signal rx_data_rdy, we, high_low, data_read: std_logic:= '0';
    signal data: std_logic_vector(7 downto 0);
    signal addr_c_input: std_logic_vector(14 downto 0) := (others => '0');
    signal data_complete: std_logic_vector(15 downto 0);
begin

    B0: block_RAM
        generic map(
            MEM_DEPTH => 15,
            MEM_WIDTH => 16
        )
        port map(
            clk => clk_pin,
            addr => addr_c,
            we => we,
            data_i => data_complete,
            data_o => data_probe
        );

	U0: uart_top
		generic map(
			BAUD_RATE => 115200,
			CLOCK_RATE => 125E6
		)
		port map(
			clk_pin => clk_pin,  	-- Clock input (from pin)
			rst_pin => rst_pin,  	-- Active HIGH reset (from pin)
			rx_data_rdy => rx_data_rdy,  	-- Button to swap high and low bits
			rxd_pin => rxd_pin,--rxd_pin,  	-- RS232 RXD pin - directly from pin
			rx_data => data 	-- 8 bit outputs
		);
    your_instance_name : vio_1
          PORT MAP (
            clk => clk_pin,
            probe_in0 => c,
            probe_in1 => addr_c,
            probe_in2 => data_probe,
            probe_out0 => addr_c_input
          );
    process(clk_pin)
    begin
        if rising_edge(clk_pin) then
            if active = '1' then
                c <= (others => '0');
                if rx_data_rdy = '1' then               
                    if data_read = '0' then
                        if high_low = '0' then
                            we <= '0';
                            data_complete(15 downto 9) <= data(6 downto 0);
                        else
                            data_complete(8 downto 2) <= data(6 downto 0);
                            we <= '1';
                            if unsigned(addr_c) = 2**15-1 then
                                active <= '0';
                                addr_c <= (others => '0');
                                we <= '0';
                            else
                                addr_c <= std_logic_vector(unsigned(addr_c) + 1);
                            end if;
                        end if;
                        data_read <= '1';
                        high_low <= not high_low;
                                 
                    end if;
                else
                    data_read <= '0';
                end if;
            else
                addr_c <= addr_c_input;
                --if unsigned(c) = 125000000*3 then
                --    c <= (others => '0');
                --    addr_c <= std_logic_vector(unsigned(addr_c) + 1);
                --else
                 --   c <= std_logic_vector(unsigned(c) + 1);
                --end if ;
            end if;
        end if;
    end process;
end;
