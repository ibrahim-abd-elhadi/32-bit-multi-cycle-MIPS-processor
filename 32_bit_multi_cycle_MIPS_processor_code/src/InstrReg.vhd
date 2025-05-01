library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity InstrReg is
  generic (
    n : integer := 32
  );
  port (
    clk       : in  std_logic;                          -- Clock signal
    reset_n   : in  std_logic;                          -- Active-low reset
    write_enable : in  std_logic;                       -- Enables writing to IR
    data_in   : in  std_logic_vector(n - 1 downto 0);   -- Instruction input
    data_out  : out std_logic_vector(n - 1 downto 0)    -- Instruction output
  );
end InstrReg;

architecture Behavioral of InstrReg is
  type reg_array is array (0 to 0) of std_logic_vector(n - 1 downto 0);
  signal register : reg_array := ((others => (others => '0')));
begin

  process(clk)
  begin
    if reset_n = '0' then
      register(0) <= (others => '0');
    elsif rising_edge(clk) and write_enable = '1' then
      register(0) <= data_in;
    end if;
  end process;

  data_out <= register(0);

end Behavioral;
