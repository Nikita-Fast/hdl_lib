library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

use std.textio.all;
use ieee.std_logic_textio.all;

entity file_writer is
generic(
    DATA_WIDTH : integer := 16;
    FILE_NAME  : string  := "output.txt"
);
port(
    clk     : in std_logic;
    enable  : in std_logic;
    data_in : in std_logic_vector(DATA_WIDTH-1 downto 0)
);
end entity;

architecture sim of file_writer is

file outfile : text open write_mode is FILE_NAME;

begin

process(clk)

    variable line_buf : line;

begin
    if rising_edge(clk) then

        if enable = '1' then

            write(line_buf, to_integer(unsigned(data_in)));
            writeline(outfile, line_buf);

        end if;

    end if;
end process;

end architecture;
