library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity MemoryDataRegister is
  port (
    clk      : in  std_logic;                           -- Clock signal
    reset_n  : in  std_logic;                           -- Active-low reset
    data_in  : in  std_logic_vector(31 downto 0);       -- Input from memory
    data_out : out std_logic_vector(31 downto 0)        -- Output to MUX
  );
end MemoryDataRegister;

architecture Behavioral of MemoryDataRegister is
  signal reg_mem_data : std_logic_vector(31 downto 0) := (others => '0');
begin

  process(clk)
  begin
    if reset_n = '0' then  -- Active-low reset
      reg_mem_data <= (others => '0');
    elsif rising_edge(clk) then
      reg_mem_data <= data_in;
    end if;
  end process;

  data_out <= reg_mem_data;

end Behavioral;
