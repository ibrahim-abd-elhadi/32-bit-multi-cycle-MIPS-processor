library ieee;
use ieee.std_logic_1164.all; 
use IEEE.STD_LOGIC_UNSIGNED.ALL;
use ieee.numeric_std.all;

entity ALU is
  port( -- input
        input_1   : in std_logic_vector(31 downto 0);
        input_2   : in std_logic_vector(31 downto 0);
        ALU_control : in std_logic_vector(3 downto 0);  

        -- output
        result      : out std_logic_vector(31 downto 0);
        zero        : out std_logic );
end ALU;

architecture Behavioral of ALU is
  signal temp : std_logic_vector(31 downto 0);

begin

  temp <=
    -- add
    	input_1 + input_2 when ALU_control = "0000" else
    -- subtract
    	input_1 - input_2 when ALU_control = "0001" else
    -- AND
   	input_1 AND  input_2 when ALU_control = "0010" else
    -- OR
    	input_1 OR   input_2 when ALU_control = "0011" else
    -- NOR
    	input_1 NOR  input_2 when ALU_control = "0100" else
    -- NAND
    	input_1 NAND input_2 when ALU_control = "0101" else
    -- XOR
    	input_1 XOR  input_2 when ALU_control = "0110" else
    -- shift left logical
    std_logic_vector(shift_left(unsigned(input_1), to_integer(unsigned(input_2(10 downto 6))))) when ALU_control = "0111" else 
	
    -- shift right logical
    std_logic_vector(shift_right(unsigned(input_1), to_integer(unsigned(input_2(10 downto 6))))) when ALU_control = "1000" else
    -- in other cases
    (others => '0');
  zero <= '1' when temp = "00000000000000000000000000000000" else '0';
  result <= temp;

end Behavioral;
