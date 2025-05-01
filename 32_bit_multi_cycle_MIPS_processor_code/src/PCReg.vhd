library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity PCReg is
  port (
    clk          : in  std_logic;                         -- Clock signal
    reset_n      : in  std_logic;                         -- Active-low reset
    pc_in        : in  std_logic_vector(31 downto 0);     -- New PC value
    load_enable  : in  std_logic;                         -- Load PC on clock edge
    pc_out       : out std_logic_vector(31 downto 0)      -- Current PC value
  );
end PCReg;

architecture Behavioral of PCReg is
begin

  process(clk)
  begin
    if reset_n = '0' then
      pc_out <= (others => '0');
    elsif rising_edge(clk) and load_enable = '1' then
      pc_out <= pc_in;
    end if;
  end process;

end Behavioral;
