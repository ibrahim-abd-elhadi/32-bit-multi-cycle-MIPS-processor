library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity Memory is
  port (
    clk         : in  std_logic;
    reset_n     : in  std_logic;
    addr        : in  std_logic_vector(31 downto 0);
    write_en    : in  std_logic;
    read_en     : in  std_logic;
    write_data  : in  std_logic_vector(31 downto 0);
    read_data   : out std_logic_vector(31 downto 0)
  );
end Memory;

architecture Behavioral of Memory is

  type memory_array is array (0 to 63) of std_logic_vector(7 downto 0);
  signal ram : memory_array := (
    -- Register aliases for comments:
    -- R0  = Zero
    -- R1  = Temp1
    -- R2  = Temp2
    -- R3  = BaseReg
    -- R10 = ResultReg
    -- R20 = MemBaseReg

    -- Program Instructions (byte-addressed)
     0 => "10001110",  1 => "10000000",  2 => "00000000",  3 => "00101111",  -- lw Zero,47(MemBaseReg)
     4 => "00100000",  5 => "01100001",  6 => "00000000",  7 => "00110010",  -- addi Temp1,BaseReg,50
     8 => "00100000",  9 => "01100010", 10 => "00000000", 11 => "00110000",  -- addi Temp2,BaseReg,48
    12 => "00000000", 13 => "01000000", 14 => "00010000", 15 => "00100000",  -- add Temp2,Temp2,Zero
    16 => "00010000", 17 => "00100010", 18 => "00000000", 19 => "00000001",  -- beq Temp1,Temp2,1
    20 => "00001000", 21 => "00000000", 22 => "00000000", 23 => "00000011",  -- j 3
    24 => "00000000", 25 => "00100010", 26 => "00000000", 27 => "00100000",  -- add Zero,Temp1,Temp2
    28 => "10001110", 29 => "10001010", 30 => "00000000", 31 => "00101111",  -- lw ResultReg,47(MemBaseReg)

  
    50 => "00000001",

    others => "00000000"
  );

begin

  process(clk)
  begin
    if rising_edge(clk) then
      if write_en = '1' then
        ram(to_integer(unsigned(addr)))     <= write_data(31 downto 24);
        ram(to_integer(unsigned(addr) + 1)) <= write_data(23 downto 16);
        ram(to_integer(unsigned(addr) + 2)) <= write_data(15 downto 8);
        ram(to_integer(unsigned(addr) + 3)) <= write_data(7 downto 0);
      end if;
    end if;
  end process;

 
  read_data <= ram(to_integer(unsigned(addr)))     &
               ram(to_integer(unsigned(addr) + 1)) &
               ram(to_integer(unsigned(addr) + 2)) &
               ram(to_integer(unsigned(addr) + 3))
               when read_en = '1'
               else (others => '0');

end Behavioral;
