library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity Registers_tb is
end Registers_tb;

architecture Behavioral of Registers_tb is

    component Registers is
        port (
            clk           : in  std_logic;
            reset         : in  std_logic;
            address_in_1  : in  std_logic_vector(4 downto 0);
            address_in_2  : in  std_logic_vector(4 downto 0);
            write_address : in  std_logic_vector(4 downto 0);
            data_in       : in  std_logic_vector(31 downto 0);
            write_enable  : in  std_logic;
            data_out_1    : out std_logic_vector(31 downto 0);
            data_out_2    : out std_logic_vector(31 downto 0)
        );
    end component;

    -- Signals
    signal clk           : std_logic := '0';
    signal reset         : std_logic := '0';
    signal address_in_1  : std_logic_vector(4 downto 0) := (others => '0');
    signal address_in_2  : std_logic_vector(4 downto 0) := (others => '0');
    signal write_address : std_logic_vector(4 downto 0) := (others => '0');
    signal data_in       : std_logic_vector(31 downto 0) := (others => '0');
    signal write_enable  : std_logic := '0';
    signal data_out_1    : std_logic_vector(31 downto 0);
    signal data_out_2    : std_logic_vector(31 downto 0);

    constant CLK_PERIOD : time := 10 ns;

begin

    -- Instantiate the DUT
    DUT: Registers
        port map (
            clk           => clk,
            reset         => reset,
            address_in_1  => address_in_1,
            address_in_2  => address_in_2,
            write_address => write_address,
            data_in       => data_in,
            write_enable  => write_enable,
            data_out_1    => data_out_1,
            data_out_2    => data_out_2
        );

    -- Clock generation
    clk_process: process
    begin
        while now < 200 ns loop
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
        ------------------------------------------------------------------
        -- Reset everything
        ------------------------------------------------------------------
        reset <= '1';
        wait for CLK_PERIOD;
        reset <= '0';
        wait for CLK_PERIOD;

        -- Check that register zero is zero after reset
        address_in_1 <= "00000";
        address_in_2 <= "00000";
        wait for 1 ns;
        assert (data_out_1 = x"00000000") report "Reset: data_out_1 not zero!" severity error;
        assert (data_out_2 = x"00000000") report "Reset: data_out_2 not zero!" severity error;

        ------------------------------------------------------------------
        -- Try to write to register zero (should have no effect)
        ------------------------------------------------------------------
        write_address <= "00000";
        data_in      <= x"F0F0F0F0";
        write_enable <= '1';
        wait for CLK_PERIOD;
        write_enable <= '0';
        wait for CLK_PERIOD;

        -- Read register zero, should still be zero
        address_in_1 <= "00000";
        wait for 1 ns;
        assert (data_out_1 = x"00000000") report "Register zero not protected from write!" severity error;

        ------------------------------------------------------------------
        -- Write and verify register 3
        ------------------------------------------------------------------
        write_address <= "00011";   -- Register 3
        data_in      <= x"12345678";
        write_enable <= '1';
        wait for CLK_PERIOD;
        write_enable <= '0';
        wait for CLK_PERIOD;

        -- Read register 3
        address_in_1 <= "00011";
        wait for 1 ns;
        assert (data_out_1 = x"12345678") report "Register 3 did not retain written value!" severity error;

        ------------------------------------------------------------------
        -- Write to register 10 and check
        ------------------------------------------------------------------
        write_address <= "01010";    -- Register 10
        data_in      <= x"CAFEBABE";
        write_enable <= '1';
        wait for CLK_PERIOD;
        write_enable <= '0';
        wait for CLK_PERIOD;

        address_in_1 <= "01010";
        wait for 1 ns;
        assert (data_out_1 = x"CAFEBABE") report "Register 10 write failed!" severity error;

        ------------------------------------------------------------------
        -- Dual read test: reg 3 (data_out_1), reg 10 (data_out_2)
        ------------------------------------------------------------------
        address_in_1 <= "00011";
        address_in_2 <= "01010";
        wait for 1 ns;
        assert (data_out_1 = x"12345678") report "Dual read: data_out_1 wrong!" severity error;
        assert (data_out_2 = x"CAFEBABE") report "Dual read: data_out_2 wrong!" severity error;

        ------------------------------------------------------------------
        -- Reset again to check clearing
        ------------------------------------------------------------------
        reset <= '1';
        wait for CLK_PERIOD;
        reset <= '0';
        wait for 1 ns;

        address_in_1 <= "00011";
        address_in_2 <= "01010";
        wait for 1 ns;
        assert (data_out_1 = x"00000000") report "After reset: Register 3 not zero!" severity error;
        assert (data_out_2 = x"00000000") report "After reset: Register 10 not zero!" severity error;

        ------------------------------------------------------------------
        -- End simulation
        ------------------------------------------------------------------
        wait for 10 ns;
        assert false report "Register file testbench finished successfully!" severity note;
        wait;
    end process;

end Behavioral;