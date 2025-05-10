library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity Memory_tb is
end Memory_tb;

architecture Behavioral of Memory_tb is

    -- Component declaration
    component Memory is
      port (
        clk         : in  std_logic;
        addr        : in  std_logic_vector(31 downto 0);
        write_en    : in  std_logic;
        read_en     : in  std_logic;
        write_data  : in  std_logic_vector(31 downto 0);
        read_data   : out std_logic_vector(31 downto 0)
      );
    end component;

    -- Signals for DUT (Device Under Test)
    signal clk        : std_logic := '0';
    signal addr       : std_logic_vector(31 downto 0) := (others => '0');
    signal write_en   : std_logic := '0';
    signal read_en    : std_logic := '0';
    signal write_data : std_logic_vector(31 downto 0) := (others => '0');
    signal read_data  : std_logic_vector(31 downto 0);

    constant CLK_PERIOD : time := 10 ns;

begin

    -- Instantiate Memory
    DUT: Memory 
        port map (
            clk        => clk,
            addr       => addr,
            write_en   => write_en,
            read_en    => read_en,
            write_data => write_data,
            read_data  => read_data
        );

    -- Clock generator
    clk_process : process
    begin
        while now < 200 ns loop
            clk <= '0';
            wait for CLK_PERIOD/2;
            clk <= '1';
            wait for CLK_PERIOD/2;
        end loop;
        wait;
    end process clk_process;

    -- Stimulus process
    stim_proc: process
    begin
        -- Wait for power-on and initial clock edges
        wait for 20 ns;

        -- Write 0xDEADBEEF to address 0x04
        addr       <= x"00000004";
        write_data <= x"DEADBEEF";
        write_en   <= '1';
        wait for CLK_PERIOD;
        write_en   <= '0';

        -- Wait for write to settle
        wait for 20 ns;

        -- Read from address 0x04
        addr     <= x"00000004";
        read_en  <= '1';
        wait for 1 ns; -- read is combinational

        -- Assert value was written (for simulation output)
        assert (read_data = x"DEADBEEF")
          report "Read data does not match written data!" severity error;

        wait for 10 ns;
        read_en  <= '0';

        -- Read from an out-of-range address (should return zeros)
        addr     <= x"00000061";
        read_en  <= '1';
        wait for 1 ns;

        assert (read_data = x"00000000")
          report "Out of range read did not return zero!" severity error;

        wait for 10 ns;
        read_en  <= '0';

        -- Finish simulation
        wait for 60 ns;
        assert false report "Testbench finished!" severity note;
        wait;
    end process stim_proc;

end Behavioral;