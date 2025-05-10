													 library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity AB_Reg_tb is
end AB_Reg_tb;

architecture Behavioral of AB_Reg_tb is

    -- DUT component declaration
    component AB_Reg is
        port(
            clk        : in std_logic;
            reset      : in std_logic;
            in_A       : in std_logic_vector(31 downto 0);
            in_B       : in std_logic_vector(31 downto 0);
            in_ALUout  : in std_logic_vector(31 downto 0);

            out_A      : out std_logic_vector(31 downto 0);
            out_B      : out std_logic_vector(31 downto 0);
            out_ALUout : out std_logic_vector(31 downto 0)
        );
    end component;

    -- Signals to connect to DUT
    signal clk        : std_logic := '0';
    signal reset      : std_logic := '0';
    signal in_A       : std_logic_vector(31 downto 0) := (others => '0');
    signal in_B       : std_logic_vector(31 downto 0) := (others => '0');
    signal in_ALUout  : std_logic_vector(31 downto 0) := (others => '0');

    signal out_A      : std_logic_vector(31 downto 0);
    signal out_B      : std_logic_vector(31 downto 0);
    signal out_ALUout : std_logic_vector(31 downto 0);

    constant CLK_PERIOD : time := 10 ns;

begin

    -- Instantiate DUT
    DUT: AB_Reg
        port map (
            clk        => clk,
            reset      => reset,
            in_A       => in_A,
            in_B       => in_B,
            in_ALUout  => in_ALUout,
            out_A      => out_A,
            out_B      => out_B,
            out_ALUout => out_ALUout
        );

    -- Clock generation
    clk_process : process
    begin
        while now < 100 ns loop
            clk <= '0';
            wait for CLK_PERIOD / 2;
            clk <= '1';
            wait for CLK_PERIOD / 2;
        end loop;
        wait;
    end process;

    -- Stimulus process
    stim_proc: process
    begin
        -- Initial reset
        reset <= '1';
        wait for CLK_PERIOD;
        reset <= '0';

        in_A      <= x"AAAAAAAA";
        in_B      <= x"BBBBBBBB";
        in_ALUout <= x"CCCCCCCC";

        wait for CLK_PERIOD; -- Data captured on next rising edge

        -- Check outputs after 1st data set
        wait for 1 ns; -- let combinational outputs update
        assert (out_A = x"AAAAAAAA")
            report "out_A mismatch after first write!" severity error;
        assert (out_B = x"BBBBBBBB")
            report "out_B mismatch after first write!" severity error;
        assert (out_ALUout = x"CCCCCCCC")
            report "out_ALUout mismatch after first write!" severity error;

        -- Apply a new set of data
        in_A      <= x"11112222";
        in_B      <= x"33334444";
        in_ALUout <= x"55556666";

        wait for CLK_PERIOD;

        -- Check outputs after 2nd data set
        wait for 1 ns;
        assert (out_A = x"11112222")
            report "out_A mismatch after second write!" severity error;
        assert (out_B = x"33334444")
            report "out_B mismatch after second write!" severity error;
        assert (out_ALUout = x"55556666")
            report "out_ALUout mismatch after second write!" severity error;

        -- Test reset
        reset <= '1';
        wait for CLK_PERIOD;
        reset <= '0';

        wait for 1 ns;
        assert (out_A = x"00000000")
            report "out_A mismatch after reset!" severity error;
        assert (out_B = x"00000000")
            report "out_B mismatch after reset!" severity error;
        assert (out_ALUout = x"00000000")
            report "out_ALUout mismatch after reset!" severity error;

        -- End simulation
        wait for 10 ns;
        assert false report "AB_Reg Testbench finished successfully!" severity note;
        wait;
    end process;

end Behavioral;