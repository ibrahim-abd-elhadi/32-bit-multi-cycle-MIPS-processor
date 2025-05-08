library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity InstrReg  is
  port( -- input
        clk             : in std_logic;
        reset       : in std_logic;
        IRWrite         : in std_logic;
        in_instruction  : in std_logic_vector(31 downto 0);

        -- output
        out_instruction : out std_logic_vector(31 downto 0) );
end InstrReg ;

architecture Behavioral of InstrReg  is
  type instr_reg_type is array (0 to 0) of std_logic_vector(31 downto 0);
  signal instr_reg : instr_reg_type := ((others => (others => '0')));

begin
  process(clk)
  begin
    if reset = '1' then
      instr_reg(0) <= (others => '0');
    else if rising_edge(clk) and IRWrite = '1' then
      instr_reg(0) <= in_instruction;
    end if;
    end if;
  end process;

  out_instruction <= instr_reg(0);

end Behavioral;