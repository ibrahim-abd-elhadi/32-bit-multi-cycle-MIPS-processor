library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity Mux3 is
  port(
    input_1    : in std_logic_vector(31 downto 0);
    input_2    : in std_logic_vector(31 downto 0);
    input_3    : in std_logic_vector(31 downto 0);
    mux_select : in std_logic_vector(1 downto 0);
    output     : out std_logic_vector(31 downto 0)
  );
end Mux3;

architecture Behavioral of Mux3 is
begin
  with mux_select select
    output <= input_1 when "00",
              input_2 when "01",
              input_3 when "10",
              (others => '0') when others;
end Behavioral;