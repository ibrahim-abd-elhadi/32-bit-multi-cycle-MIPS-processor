library ieee;
use ieee.std_logic_1164.all; 
use IEEE.STD_LOGIC_UNSIGNED.ALL;
use ieee.numeric_std.all;
entity ALU_TP is
end ALU_TP;
architecture test of ALU_TP is
signal input_1 : std_logic_vector(31 downto 0);
signal input_2 : std_logic_vector(31 downto 0);
signal ALU_control:std_logic_vector(3 downto 0);  
signal output :std_logic_vector(31 downto 0);
begin
L1: entity ALU
    port map (input_1 => input_1, 
              input_2 => input_2, 
              ALU_control => ALU_control, 
              result => output);
         stim_proc: process
begin
	 -- test add
    input_1 <=  x"00000001";
    input_2 <=  x"00000010";
    ALU_control <= "0000"; 
    wait for 10 ns;
	-- test subtract
    ALU_control <= "0001"; 
    wait for 10 ns;
    -- Test ADD
    ALU_control <= "0010";
    wait for 10 ns;
	-- Test OR
    ALU_control <= "0011"; 
    wait for 10 ns;
	-- Test NOR
	ALU_control <= "0100"; 
    wait for 10 ns;
		-- Test NAND
	ALU_control <= "0101"; 
    wait for 10 ns;	
		-- Test XOR
	ALU_control <= "0110"; 
    wait for 10 ns;
	-- test shift left logical
	input_1 <=  x"00000001";
	input_2 <=  "00000000000000000000000101000000";--value of shift =5  
	ALU_control <= "0111";
	wait for 10 ns;

	-- test shift right logical
	input_1 <=  x"00000001";
	input_2 <=  "00000000000000000000000101000000";--value of shift =5  
	ALU_control <= "1000";
	wait for 10 ns;
		
    wait; -- End of simulation
end process;

end architecture ;
