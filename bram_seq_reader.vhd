library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity bram_seq_reader is
generic(
    N            : integer := 256;
    ADDR_WIDTH   : integer := 8;
    DATA_WIDTH   : integer := 16;
    CIRCULAR     : boolean := false;
    BRAM_LATENCY : integer := 2
);
port(
    clk     : in  std_logic;
    rst     : in  std_logic;
    enable  : in  std_logic;

    bram_addr : out std_logic_vector(ADDR_WIDTH-1 downto 0);
    bram_data : in  std_logic_vector(DATA_WIDTH-1 downto 0);

    tdata  : out std_logic_vector(DATA_WIDTH-1 downto 0);
    tvalid : out std_logic
);
end entity;

architecture rtl of bram_seq_reader is

signal addr_cnt : integer range 0 to N := 0;
signal active   : std_logic := '1';

signal valid_pipe : std_logic_vector(BRAM_LATENCY-1 downto 0) := (others=>'0');

begin

process(clk)
begin
if rising_edge(clk) then

    if rst='1' then
        addr_cnt   <= 0;
        active     <= '1';
        valid_pipe <= (others=>'0');

    else

        -- pipeline valid
        valid_pipe(valid_pipe'high downto 1) <= valid_pipe(valid_pipe'high-1 downto 0);
        valid_pipe(0) <= enable and active;

        -- адресная логика
        if enable='1' and active='1' then

            if addr_cnt = N-1 then

                if CIRCULAR then
                    addr_cnt <= 0;
                else
                    active <= '0';
                end if;

            else
                addr_cnt <= addr_cnt + 1;
            end if;

        end if;

    end if;

end if;
end process;

bram_addr <= std_logic_vector(to_unsigned(addr_cnt, ADDR_WIDTH));

tdata  <= bram_data;
tvalid <= valid_pipe(valid_pipe'high);

end architecture;