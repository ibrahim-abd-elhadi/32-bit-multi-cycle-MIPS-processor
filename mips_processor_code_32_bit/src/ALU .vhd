library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity ALU is
  port (
    input_1     : in std_logic_vector(31 downto 0);
    input_2     : in std_logic_vector(31 downto 0);
    ALU_control : in std_logic_vector(3 downto 0);
    result      : out std_logic_vector(31 downto 0);
    zero        : out std_logic
  );
end ALU;

architecture Behavioral of ALU is
  signal temp : std_logic_vector(31 downto 0);
begin

  temp <=
    std_logic_vector(unsigned(input_1) + unsigned(input_2))                                                        when ALU_control = "0000" else -- ADD
    std_logic_vector(unsigned(input_1) - unsigned(input_2))                                                        when ALU_control = "0001" else -- SUB
    input_1 and input_2                                                                                            when ALU_control = "0010" else -- AND
    input_1 or input_2                                                                                             when ALU_control = "0011" else -- OR
    not (input_1 or input_2)                                                                                       when ALU_control = "0100" else -- NOR
    not (input_1 and input_2)                                                                                      when ALU_control = "0101" else -- NAND
    input_1 xor input_2                                                                                            when ALU_control = "0110" else -- XOR
    std_logic_vector(shift_left(unsigned(input_1), to_integer(unsigned(input_2(10 downto 6)))))                    when ALU_control = "0111" else -- SLL
    std_logic_vector(shift_right(unsigned(input_1), to_integer(unsigned(input_2(10 downto 6)))))                   when ALU_control = "1000" else -- SRL
    x"00000000"; -- default (also covers others)

  zero <= '1' when temp = x"00000000" else '0';
  result <= temp;

end Behavioral;