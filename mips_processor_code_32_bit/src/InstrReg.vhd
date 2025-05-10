library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity InstrReg is
  port(
    clk             : in std_logic;
    reset           : in std_logic;
    IRWrite         : in std_logic;
    in_instruction  : in std_logic_vector(31 downto 0);
    out_instruction : out std_logic_vector(31 downto 0)
  );
end InstrReg;

architecture Behavioral of InstrReg is
  signal instr_reg : std_logic_vector(31 downto 0) := (others => '0');
begin
  process(clk,reset)
  begin
    if reset = '1' then
      instr_reg <= (others => '0');
    elsif rising_edge(clk) and IRWrite = '1' then
      instr_reg <= in_instruction;
    end if;
  end process;

  out_instruction <= instr_reg;
end Behavioral;