library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity tlast_generator is
    generic (
        TARGET_ADDR : integer := 100  -- Адрес, при котором формируется tlast
    );
    port (
        clk         : in  std_logic;
        reset       : in  std_logic;
        address     : in  std_logic_vector(31 downto 0);  -- Входной адрес
        tlast       : out std_logic                        -- Выходной сигнал tlast
    );
end entity tlast_generator;

architecture Behavioral of tlast_generator is
    signal address_int : integer;
begin
    process(clk)
    begin
        if rising_edge(clk) then
            if reset = '1' then
                tlast <= '0';
            else
                -- Преобразуем адрес в integer для сравнения
                address_int <= to_integer(unsigned(address));
                
                -- Формируем tlast на один такт при совпадении адреса
                if address_int = TARGET_ADDR then
                    tlast <= '1';
                else
                    tlast <= '0';
                end if;
            end if;
        end if;
    end process;
end architecture Behavioral;
