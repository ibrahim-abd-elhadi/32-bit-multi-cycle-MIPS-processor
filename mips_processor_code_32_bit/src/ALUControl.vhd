LIBRARY IEEE;
USE IEEE.std_logic_1164.ALL;

ENTITY ALUControl IS
    PORT (
        instr_5_0 : IN  std_logic_vector(5 downto 0);
        ALUOp      : IN  std_logic_vector(1 downto 0);
        ALUopcode  : OUT std_logic_vector(3 downto 0)
    );
END ALUControl;

ARCHITECTURE behave OF ALUControl IS
BEGIN

    Alu_Control : PROCESS(instr_5_0, ALUOp)  -- instr from 0 to 15 to support both types of insttructions
        
    BEGIN
        CASE ALUOp IS
            WHEN "00" =>
                ALUopcode <= "0000";  -- ADD

            WHEN "01" =>
                ALUopcode <= "0001";  -- SUBTRACT

            WHEN "10" =>
                CASE instr_5_0 IS
                    WHEN "100000" =>
                        ALUopcode <= "0000";  -- ADD
                    WHEN "100010" =>
                        ALUopcode <= "0001";  -- SUBTRACT
                    WHEN "100100" =>
                        ALUopcode <= "0010";  -- AND
                    WHEN "100101" =>
						ALUopcode <= "0011";  -- OR
					WHEN "100111" =>
						ALUopcode <= "0100";  -- NOR
					WHEN "101111" =>
                        ALUopcode <= "0101";  -- NAND
					WHEN "100110" =>
                        ALUopcode <= "0110";  -- XOR
                    WHEN "101010" =>
						ALUopcode <= "0111";  -- SLT
					WHEN "000010" =>
                        ALUopcode <= "1000";  -- SRT
                    WHEN OTHERS =>
                        ALUopcode <= "1111";  -- DEFAULT
                END CASE;

            WHEN OTHERS =>
                ALUopcode <= "1111";  -- DEFAULT
        END CASE;
    END PROCESS;

END behave;
