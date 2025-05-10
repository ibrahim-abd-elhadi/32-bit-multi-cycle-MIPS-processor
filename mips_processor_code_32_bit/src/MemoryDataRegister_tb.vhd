library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity MemoryDataRegister_tb is
end MemoryDataRegister_tb;

architecture Behavioral of MemoryDataRegister_tb is

    component MemoryDataRegister is
      port (
        clk      : in  std_logic;
        reset    : in  std_logic;
        data_in  : in  std_logic_vector(31 downto 0);
        data_out : out std_logic_vector(31 downto 0)
      );
    end component;

    signal clk      : std_logic := '0';
    signal reset    : std_logic := '0';
    signal data_in  : std_logic_vector(31 downto 0) := (others => '0');
    signal data_out : std_logic_vector(31 downto 0);

    constant CLK_PERIOD : time := 10 ns;

begin

    -- DUT instantiation
    DUT: MemoryDataRegister port map (
        clk      => clk,
        reset    => reset,
        data_in  => data_in,
        data_out => data_out
    );

    -- Clock generator
    clk_process : process
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
        -- Apply and release reset
        reset <= '1';
        wait for CLK_PERIOD;
        reset <= '0';
        wait for 1 ns;
        assert (data_out = x"00000000")
          report "Failure: Register not cleared on reset!" severity error;

        -- Write 1st value
        data_in <= x"DEADBEEF";
        wait for CLK_PERIOD;
        assert (data_out = x"DEADBEEF")
          report "Failure: Register did not load first value!" severity error;

        -- Write 2nd value
        data_in <= x"12345678";
        wait for CLK_PERIOD;
        assert (data_out = x"12345678")
          report "Failure: Register did not load second value!" severity error;

        -- Reassert reset, should clear reg
        reset <= '1';
        wait for CLK_PERIOD;
        reset <= '0';
        wait for 1 ns;
        assert (data_out = x"00000000")
          report "Failure: Register not cleared after second reset!" severity error;

        -- End simulation
        wait for 10 ns;
        assert false report "MemoryDataRegister testbench finished successfully!" severity note;
        wait;
    end process;

end Behavioral;