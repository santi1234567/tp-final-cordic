-------------------------------------------------------------------------------
-- Company:
-- Engineer:
--
-- Create Date: 10/19/2015 10:24:29 AM
-- Design Name:
-- Module Name: uart_top_VIO
-- Project Name:
-- Target Devices:
-- Tool Versions:
-- Description:
--
-- Dependencies:
--
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
--
--////////////////////////////////////////////////////////////////////////////////

library IEEE;
use IEEE.std_logic_1164.all;

entity uart_top_VIO is
	port(
		--Write side inputs
		clk_pin: in std_logic;		-- Clock input (from pin)
		rxd_pin: in std_logic		-- Uart input
	);
end;


architecture uart_top_VIO_arq of uart_top_VIO is

	component uart_led is
		generic(
			BAUD_RATE: integer := 115200;
			CLOCK_RATE: integer := 50E6
		);
		port(
			-- Write side inputs
			clk_pin:	in std_logic;      					-- Clock input (from pin)
			rst_pin: 	in std_logic;      					-- Active HIGH reset (from pin)
			btn_pin: 	in std_logic;      					-- Button to swap high and low bits
			rxd_pin: 	in std_logic;      					-- RS232 RXD pin - directly from pin
			led_pins: 	out std_logic_vector(3 downto 0)    -- 8 LED outputs
		);
	end component;
	COMPONENT vio_0
      PORT (
        clk : IN STD_LOGIC;
        probe_in0 : IN STD_LOGIC_VECTOR(3 DOWNTO 0);
        probe_out0 : OUT STD_LOGIC_VECTOR(0 DOWNTO 0);
        probe_out1 : OUT STD_LOGIC_VECTOR(0 DOWNTO 0)
      );
    END COMPONENT;
	signal btn_probe, rst_probe: std_logic_vector(0 downto 0);
	signal led_probe: std_logic_vector(3 downto 0);
begin

	U0: uart_led
		generic map(
			BAUD_RATE => 115200,
			CLOCK_RATE => 125E6
		)
		port map(
			clk_pin => clk_pin,  	-- Clock input (from pin)
			rst_pin => rst_probe(0),  	-- Active HIGH reset (from pin)
			btn_pin => btn_probe(0),  	-- Button to swap high and low bits
			rxd_pin => rxd_pin,  	-- RS232 RXD pin - directly from pin
			led_pins => led_probe 	-- 8 LED outputs
		);
		vio_inst : vio_0
          PORT MAP (
            clk => clk_pin,
            probe_in0 => led_probe,
            probe_out0 => rst_probe,
            probe_out1 => btn_probe
          );
end;
