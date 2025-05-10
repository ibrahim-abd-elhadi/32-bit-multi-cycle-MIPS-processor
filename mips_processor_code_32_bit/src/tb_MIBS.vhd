library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity tb_MIPS is
end tb_MIPS;

architecture Behavioral of tb_MIPS is

  signal clk : std_logic := '0';
  signal rst : std_logic := '1';
  signal en  : std_logic := '0';

  component MIPS
    port (
      clk : in std_logic;
      rst : in std_logic;
      en  : in std_logic
    );
  end component;

begin

  UUT: MIPS
    port map (
      clk => clk,
      rst => rst,
      en  => en
    );

  -- Clock process (20ns period)
  clk_process : process
  begin
    while now < 2 ms loop
      clk <= '0';
      wait for 10 ns;
      clk <= '1';
      wait for 10 ns;
    end loop;
    wait;
  end process;

  -- Stimulus process
  stim_proc: process
  begin
    rst <= '1';
    en  <= '0';
    wait for 100 ns;
    rst <= '0';
    en  <= '1';
    wait for 1900 ns;   -- Adjust for your program length
    -- Optionally: wait longer to run more instructions
    en <= '0';
    report "Simulation finished." severity note;
    wait;
  end process;

end Behavioral;