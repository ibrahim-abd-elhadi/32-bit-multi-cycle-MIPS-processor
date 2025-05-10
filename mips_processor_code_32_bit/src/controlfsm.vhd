library ieee;
use ieee.std_logic_1164.all;

entity ControlFSM is
    port (
        clk, rst         : in std_logic;
        instr_31_26      : in std_logic_vector(5 downto 0);
        RegDst, RegWrite,
        ALUSrcA, MemRead,
        MemWrite, MemtoReg,
        IorD, IRWrite,
        PCWrite, PCWriteCond : out std_logic;
        ALUOp, ALUSrcB,
        PCSource             : out std_logic_vector(1 downto 0)
    );
end ControlFSM;

architecture behave of ControlFSM is
    signal state, next_state : integer := 0;
begin

    -- State register
    state_reg: process(clk, rst)
    begin
        if rst = '1' then
            state <= 0;
        elsif rising_edge(clk) then
            state <= next_state;
        end if;
    end process;

    -- Logic process
    logic_process: process(state, instr_31_26)
        variable control_signals : std_logic_vector(15 downto 0);
    begin
        case state is
            -- Instruction Fetch
            when 0 =>
                control_signals := "0001000110000100";
                next_state <= 1;
            -- Instruction Decode & Register Fetch
            when 1 =>
                control_signals := "0000000000001100";
                if instr_31_26 = "100011" or instr_31_26 = "101011" then
                    next_state <= 2;
                elsif instr_31_26 = "000000" then
                    next_state <= 6;
                elsif instr_31_26 = "000100" then
                    next_state <= 8;
                elsif instr_31_26 = "000010" then
                    next_state <= 9;
                elsif instr_31_26 = "001000" then
                    next_state <= 6;
                else
                    next_state <= 10;
                end if;
            -- Memory Address Computation
            when 2 =>
                control_signals := "0010000000001000";
                if instr_31_26 = "100011" then
                    next_state <= 3;
                elsif instr_31_26 = "101011" then
                    next_state <= 5;
                else
                    next_state <= 10;
                end if;
            -- Memory Access Load Word
            when 3 =>
                control_signals := "0011001000001000";
                next_state <= 4;
            -- Memory Read Completion
            when 4 =>
                control_signals := "0110010000001000";
                next_state <= 0;
            -- Memory Access Store Word
            when 5 =>
                control_signals := "0010101000001000";
                next_state <= 0;
            -- Execution
            when 6 =>
                control_signals := "0010000000100000";
                next_state <= 7;
            -- R-type Completion
            when 7 =>
                control_signals := "1110000000100000";
                next_state <= 0;
            -- Branch Completion
            when 8 =>
                control_signals := "0010000001010001";
                next_state <= 0;
            -- Jump Completion
            when 9 =>
                control_signals := "0000000010001110";
                next_state <= 0;
            -- Default
            when others =>
                control_signals := (others => 'X');
                next_state <= 10;
        end case;

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

    end process;

end behave;