library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity PCReg_tb is
end PCReg_tb;

architecture Behavioral of PCReg_tb is

  component PCReg is
    port (
      clk          : in  std_logic;
      reset        : in  std_logic;
      pc_in        : in  std_logic_vector(31 downto 0);
      load_enable  : in  std_logic;
      pc_out       : out std_logic_vector(31 downto 0)
    );
  end component;

  signal clk         : std_logic := '0';
  signal reset       : std_logic := '0';
  signal pc_in       : std_logic_vector(31 downto 0) := (others => '0');
  signal load_enable : std_logic := '0';
  signal pc_out      : std_logic_vector(31 downto 0);

  constant CLK_PERIOD : time := 10 ns;

begin

  -- Instantiate the DUT
  DUT: PCReg port map (
    clk         => clk,
    reset       => reset,
    pc_in       => pc_in,
    load_enable => load_enable,
    pc_out      => pc_out
  );

  -- Clock process
  clk_process: process
  begin
    while now < 100 ns loop
      clk <= '0';
      wait for CLK_PERIOD/2;
      clk <= '1';
      wait for CLK_PERIOD/2;
    end loop;
    wait;
  end process;

  -- Stimulus process
  stim_proc: process
  begin
    -- Assert reset
    reset <= '1';
    wait for CLK_PERIOD;
    reset <= '0';

    -- Try to load with load_enable = '0' (should not change)
    pc_in <= x"00000011";
    load_enable <= '0';
    wait for CLK_PERIOD;
    assert (pc_out = x"00000000") report "PC loaded when load_enable=0!" severity error;

    -- Correct load
    load_enable <= '1';
    wait for CLK_PERIOD;
    load_enable <= '0';
    assert (pc_out = x"00000011") report "PC did not load new value!" severity error;

    -- Change input, but don't load (should keep old value)
    pc_in <= x"11110000";
    wait for CLK_PERIOD;
    assert (pc_out = x"00000011") report "PC changed when load_enable=0!" severity error;

    -- Test reset again
    reset <= '1';
    wait for CLK_PERIOD;
    reset <= '0';
    assert (pc_out = x"00000000") report "PC not reset!" severity error;

    -- Finish simulation
    wait for 10 ns;
    assert false report "PCReg testbench passed!" severity note;
    wait;
  end process;

end Behavioral;