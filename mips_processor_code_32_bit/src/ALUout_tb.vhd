library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity ALUout_tb is
end ALUout_tb;

architecture Behavioral of ALUout_tb is

    component ALUout is
        port (
            input  : in  std_logic_vector(31 downto 0);
            output : out std_logic_vector(31 downto 0);
            en     : in  std_logic;
            reset  : in  std_logic;
            Clk    : in  std_logic
        );
    end component;

    -- test signals
    signal input  : std_logic_vector(31 downto 0) := (others => '0');
    signal output : std_logic_vector(31 downto 0);
    signal en     : std_logic := '0';
    signal reset  : std_logic := '0';
    signal Clk    : std_logic := '0';

    constant CLK_PERIOD : time := 10 ns;

begin

    -- Instantiate the DUT
    DUT : ALUout
        port map (
            input  => input,
            output => output,
            en     => en,
            reset  => reset,
            Clk    => Clk
        );

    -- Clock generator
    clk_process : process
    begin
        while now < 100 ns loop
            Clk <= '0';
            wait for CLK_PERIOD/2;
            Clk <= '1';
            wait for CLK_PERIOD/2;
        end loop;
        wait;
    end process;

    -- Stimulus process
    stim_proc: process
    begin
        -- Initial reset: make sure register is cleared
        reset <= '1';
        wait for CLK_PERIOD;
        reset <= '0';
        wait for 1 ns;
        assert (output = x"00000000")
          report "Failure: Output not reset to zero!" severity error;

        -- Write value with en = 1
        input <= x"12345678";
        en    <= '1';
        wait for CLK_PERIOD;
        en    <= '0'; -- disable load
        wait for 1 ns;
        assert (output = x"12345678")
          report "Failure: Did not capture input on clock/en!" severity error;

        -- Change input with en = 0 (should hold old value)
        input <= x"AAAA5555";
        wait for CLK_PERIOD;
        wait for 1 ns;
        assert (output = x"12345678")
          report "Failure: Output changed with en=0!" severity error;

        -- Set en = 1, should capture new input
        en    <= '1';
        wait for CLK_PERIOD;
        en    <= '0';
        wait for 1 ns;
        assert (output = x"AAAA5555")
          report "Failure: Did not capture new input!" severity error;

        -- Another reset test
        reset <= '1';
        wait for CLK_PERIOD;
        reset <= '0';
        wait for 1 ns;
        assert (output = x"00000000")
          report "Failure: Output not cleared by reset (second check)!" severity error;

        -- Finish
        wait for 10 ns;
        assert false report "ALUout testbench finished successfully!" severity note;
        wait;
    end process;

end Behavioral;