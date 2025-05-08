library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity ALUout is
	port (
	input : in std_logic_vector(31 downto 0);
	output : out std_logic_vector(31 downto 0) := X"00000000";
	en : in std_logic;
	reset : in std_logic;
	Clk : in std_logic
	);
end entity;

architecture archReg of ALUout is 
signal regOut : std_logic_vector(31 downto 0);
begin
	process (Clk, en, reset)
	begin
		if reset = '1' then
			regOut <= (others => '0' );
		elsif rising_edge(Clk) and en = '1' then 
			regOut <= input;
			end if;
		end process;
		output <= regOut;
end archReg;