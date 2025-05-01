library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity Registers is
  port (
    clk           : in  std_logic;                            -- Clock signal
    reset_n       : in  std_logic;                            -- Active-low reset
    address_in_1  : in  std_logic_vector(4 downto 0);         -- Read address 1
    address_in_2  : in  std_logic_vector(4 downto 0);         -- Read address 2
    write_address : in  std_logic_vector(4 downto 0);         -- Write address
    data_in       : in  std_logic_vector(31 downto 0);        -- Data to write
    write_enable  : in  std_logic;                            -- Write enable

    data_out_1    : out std_logic_vector(31 downto 0);        -- Output from reg 1
    data_out_2    : out std_logic_vector(31 downto 0)         -- Output from reg 2
  );
end Registers;

architecture Behavioral of Registers is
  type registers_array is array (0 to 31) of std_logic_vector(31 downto 0);
  signal register_file : registers_array := (others => (others => '0'));
begin

  process(clk)
  begin
    if reset_n = '0' then
      register_file(to_integer(unsigned(write_address))) <= (others => '0');
    elsif rising_edge(clk) and write_enable = '1' then
      register_file(to_integer(unsigned(write_address))) <= data_in;
    end if;
  end process;

  -- Combinational read
  data_out_1 <= register_file(to_integer(unsigned(address_in_1)));
  data_out_2 <= register_file(to_integer(unsigned(address_in_2)));

end Behavioral;
