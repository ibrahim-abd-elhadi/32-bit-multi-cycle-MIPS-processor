library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity MIPS_tb is
end entity;

architecture sim of MIPS_tb is
  signal clk   : std_logic := '0';
  signal rst   : std_logic := '1';
  signal en    : std_logic := '0';

  -- Clock period definition
  constant clk_period : time := 10 ns;

  -- Component Under Test
  component MIPS
    port (
      clk : in std_logic;
      rst : in std_logic;
      en  : in std_logic
    );
  end component;

begin
  -- Instantiate the MIPS processor
  uut: MIPS
    port map (
      clk => clk,
      rst => rst,
      en  => en
    );

  -- Clock generation
  clk_process : process
  begin
    while true loop
      clk <= '0';
      wait for clk_period / 2;
      clk <= '1';
      wait for clk_period / 2;
    end loop;
    wait;
  end process;

  -- Stimulus process
  stim_proc: process
  begin
    -- Initial values
    rst <= '1';
    en  <= '0';

    wait for 10 ns;
    rst <= '0';  -- Deassert reset
    en  <= '1';  -- Enable processor

    -- Run simulation for some time
    wait for 2000 ns;

    -- Optionally disable
    en <= '0';

    wait for 1000 ns;
    assert false report "Simulation Finished" severity failure;
  end process;

end architecture;
