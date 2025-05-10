 library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity InstrReg_tb is
end InstrReg_tb;

architecture Behavioral of InstrReg_tb is

    component InstrReg is
        port(
            clk             : in std_logic;
            reset           : in std_logic;
            IRWrite         : in std_logic;
            in_instruction  : in std_logic_vector(31 downto 0);
            out_instruction : out std_logic_vector(31 downto 0)
        );
    end component;

    signal clk             : std_logic := '0';
    signal reset           : std_logic := '0';
    signal IRWrite         : std_logic := '0';
    signal in_instruction  : std_logic_vector(31 downto 0) := (others => '0');
    signal out_instruction : std_logic_vector(31 downto 0);

    constant CLK_PERIOD : time := 10 ns;

begin

    -- Instantiate the DUT
    DUT: InstrReg
        port map (
            clk             => clk,
            reset           => reset,
            IRWrite         => IRWrite,
            in_instruction  => in_instruction,
            out_instruction => out_instruction
        );

    -- Clock generator
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
        wait for 1 ns;
        assert (out_instruction = x"00000000")
            report "Failure: Register not cleared on reset!" severity error;

        -- Write with IRWrite = '0' (should stay zero)
        in_instruction <= x"F0A5C0DE";
        IRWrite <= '0';
        wait for CLK_PERIOD;
        assert (out_instruction = x"00000000")
            report "Failure: Register loaded value when IRWrite = 0!" severity error;

        -- Write with IRWrite = '1'
        IRWrite <= '1';
        wait for CLK_PERIOD;
        IRWrite <= '0';
        assert (out_instruction = x"F0A5C0DE")
            report "Failure: Register did not load value when IRWrite = 1!" severity error;

        -- Change input with IRWrite = '0' (should NOT change output)
        in_instruction <= x"12345678";
        IRWrite <= '0';
        wait for CLK_PERIOD;
        assert (out_instruction = x"F0A5C0DE")
            report "Failure: Register changed without IRWrite enable!" severity error;

        -- Re-apply reset, output should clear to zero
        reset <= '1';
        wait for CLK_PERIOD;
        reset <= '0';
        wait for 1 ns;
        assert (out_instruction = x"00000000")
            report "Failure: Register not cleared after second reset!" severity error;

        -- End simulation
        wait for 10 ns;
        assert false report "InstrReg testbench finished successfully!" severity note;
        wait;
    end process;

end Behavioral;