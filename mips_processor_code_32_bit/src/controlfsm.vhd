LIBRARY IEEE;
USE IEEE.std_logic_1164.ALL;

ENTITY ControlFSM IS
    PORT (
        clk, rst         : IN std_logic;
        instr_31_26        : IN std_logic_vector(5 downto 0);
        RegDst, RegWrite,
        ALUSrcA, MemRead,
        MemWrite, MemtoReg,
        IorD, IRWrite,
        PCWrite, PCWriteCond : OUT std_logic;
        ALUOp, ALUSrcB,
        PCSource             : OUT std_logic_vector(1 downto 0)
    );
END ControlFSM;

ARCHITECTURE behave OF ControlFSM IS
  
  
    SIGNAL state, next_state : INTeger ;	
	
BEGIN

    ----------------------------------------------------------------------------
    -- State process
    state_reg : PROCESS(clk, rst)
    BEGIN
        IF rst = '1' THEN
            state <= 0;	 
			--stateK <= 0;
        ELSIF RISING_EDGE(clk) THEN
            state <= next_state;
        END IF;
    END PROCESS;

    ----------------------------------------------------------------------------
    -- Logic Process
    logic_process : PROCESS(state, instr_31_26)
      
        VARIABLE control_signals : std_logic_vector(15 downto 0);

    BEGIN
        CASE state IS

            -- Instruction Fetch
            WHEN 0 =>
                control_signals := "0001000110000100";
                next_state <= 1;

            -- Instruction Decode and Register Fetch
            WHEN 1 =>
                control_signals := "0000000000001100";
                IF instr_31_26 = "100011" OR instr_31_26 = "101011" THEN
                    next_state <= 2;
                ELSIF instr_31_26 = "000000" THEN
                    next_state <= 6;
                ELSIF instr_31_26 = "000100" THEN
                    next_state <= 8;
                ELSIF instr_31_26 = "000010" THEN
                    next_state <= 9;
				ELSIF instr_31_26 = "001000" THEN
                    next_state <= 6;
                ELSE
                    next_state <= 10;
                END IF;

            -- Memory Address Computation
            WHEN 2 =>
                control_signals := "0010000000001000";
                IF instr_31_26 = "100011" THEN
                    next_state <= 3;
                ELSIF instr_31_26 = "101011" THEN
                    next_state <= 5;
                ELSE
                    next_state <= 10;
                END IF;

            -- Memory Access Load Word
            WHEN 3 =>
                control_signals := "0011001000001000";
                next_state <= 4;

            -- Memory Read Completion
            WHEN 4 =>
                control_signals := "0110010000001000";
                next_state <= 0;

            -- Memory Access Store Word
            WHEN 5 =>
                control_signals := "0010101000001000";
                next_state <= 0;

            -- Execution
            WHEN 6 =>
                control_signals := "0010000000100000";
                next_state <= 7;

            -- R-type Completion
            WHEN 7 =>
                control_signals := "1110000000100000";
                next_state <= 0;

            -- Branch Completion
            WHEN 8 =>
                control_signals := "0010000001010001";
                next_state <= 0;

            -- Jump Completion
            WHEN 9 =>
                control_signals := "0000000010001110";
                next_state <= 0;

            -- Default case
            WHEN OTHERS =>
                control_signals := (others => 'X');
                next_state <= 10;

        END CASE;

        -- Assign control signals to outputs
        RegDst      <= control_signals(15);
        RegWrite    <= control_signals(14);
        ALUSrcA     <= control_signals(13);
        MemRead     <= control_signals(12);
        MemWrite    <= control_signals(11);
        MemtoReg    <= control_signals(10);
        IorD        <= control_signals(9);
        IRWrite     <= control_signals(8);
        PCWrite     <= control_signals(7);
        PCWriteCond <= control_signals(6);
        ALUOp       <= control_signals(5 downto 4);
        ALUSrcB     <= control_signals(3 downto 2);
        PCSource    <= control_signals(1 downto 0);

    END PROCESS;

END behave;
