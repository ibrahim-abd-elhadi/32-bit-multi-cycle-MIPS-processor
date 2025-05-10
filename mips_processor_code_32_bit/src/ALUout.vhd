library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity ALUout is
    port (
        input  : in  std_logic_vector(31 downto 0);
        output : out std_logic_vector(31 downto 0);
        en     : in  std_logic;
        reset  : in  std_logic;
        clk    : in  std_logic
    );
end entity;

architecture archReg of ALUout is 
    signal regOut : std_logic_vector(31 downto 0) := (others => '0');
begin
    process (Clk,reset)
    begin
        if reset = '1' then
            regOut <= (others => '0');
        elsif rising_edge(Clk) then
            if en = '1' then
                regOut <= input;
            end if;
        end if;
    end process;

    output <= regOut;
end archReg;