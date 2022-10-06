library IEEE;
use IEEE.std_logic_1164.all;
use ieee.numeric_std.all;

entity cordic_pre_processor is
  -- N tamanio de entradas/salidas
	generic(N: integer:=4);
	port(
		z_i		: in std_logic_vector(N-1 downto 0);
	    y_i		: in std_logic_vector(N-1 downto 0);
	    x_i		: in std_logic_vector(N-1 downto 0);
	    z_o		: out std_logic_vector(N-1 downto 0);
	    y_o		: out std_logic_vector(N-1 downto 0);
	    x_o		: out std_logic_vector(N-1 downto 0);
        clk_i	: in std_logic;
		rst_i	: in std_logic
	);
end;

architecture cordic_pre_processor_arq of cordic_pre_processor is
    signal pre_z, pre_y, pre_x: std_logic_vector(N-1 downto 0); -- Preprocessor variables
    begin
        process(clk_i, rst_i)
            constant pi_div_2: integer:= ((2**N)-1)/4;
            constant pi_mul_3_div_2: integer:= -1*pi_div_2;
            constant pi: integer:= ((2**N)-1)/2;
        begin
            -- PREPROCESSOR
            if signed(z_i) > pi_div_2 then
                pre_z <= std_logic_vector(signed(z_i) -  pi);
                pre_y <= std_logic_vector(to_signed(integer(0),N)-signed(y_i));
                pre_x <= std_logic_vector(to_signed(integer(0),N)-signed(x_i));
                report "Menos";
                report "Valor z_i: " & integer'image(to_integer(signed(z_i)));
                report "Valor pre_z: " & integer'image(to_integer(signed(pre_z)));
                report "Valor y_i: " & integer'image(to_integer(signed(y_i)));
                report "Valor pre_y: " & integer'image(to_integer(signed(pre_y)));
                report "Valor x_i: " & integer'image(to_integer(signed(x_i)));
                report "Valor pre_x: " & integer'image(to_integer(signed(pre_x)));
            elsif signed(z_i) < pi_mul_3_div_2 then
                report "Mas";
                pre_z <= std_logic_vector(signed(z_i) +  pi);
                pre_y <= std_logic_vector(to_signed(integer(0),N)-signed(y_i));
                pre_x <= std_logic_vector(to_signed(integer(0),N)-signed(x_i));
                report "Valor z_i: " & integer'image(to_integer(signed(z_i)));
                report "Valor pre_z: " & integer'image(to_integer(signed(pre_z)));
                report "Valor y_i: " & integer'image(to_integer(signed(y_i)));
                report "Valor pre_y: " & integer'image(to_integer(signed(pre_y)));
                report "Valor x_i: " & integer'image(to_integer(signed(x_i)));
                report "Valor pre_x: " & integer'image(to_integer(signed(pre_x)));
            else
                pre_z <= z_i;
                pre_y <= y_i;
                pre_x <= x_i;
            end if;
    end process;

    z_o <= pre_z;
    y_o <= pre_y;
    x_o <= pre_x;
end cordic_pre_processor_arq;