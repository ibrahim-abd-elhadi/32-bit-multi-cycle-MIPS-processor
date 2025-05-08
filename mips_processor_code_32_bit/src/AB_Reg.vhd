library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity AB_Reg is
  port(
    clk        : in std_logic;
    reset    : in std_logic;
    in_A       : in std_logic_vector(31 downto 0);
    in_B       : in std_logic_vector(31 downto 0);
    in_ALUout  : in std_logic_vector(31 downto 0);

    out_A      : out std_logic_vector(31 downto 0);
    out_B      : out std_logic_vector(31 downto 0);
    out_ALUout : out std_logic_vector(31 downto 0)
  );
end AB_Reg;

architecture Behavioral of AB_Reg is
  type register_array is array (0 to 2) of std_logic_vector(31 downto 0);
  signal regs : register_array := (others => (others => '0'));
begin
  process(clk)
  begin
    if reset = '1' then
      regs <= (others => (others => '0'));
    elsif rising_edge(clk) then
      regs(0) <= in_A;
      regs(1) <= in_B;
      regs(2) <= in_ALUout;
    end if;
  end process;

  out_A      <= regs(0);
  out_B      <= regs(1);
  out_ALUout <= regs(2);
end Behavioral;