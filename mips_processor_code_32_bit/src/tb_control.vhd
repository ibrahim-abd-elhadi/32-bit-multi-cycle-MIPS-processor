LIBRARY IEEE;
USE IEEE.std_logic_1164.ALL;
USE IEEE.numeric_std.ALL;

ENTITY tb_control IS
END tb_control;

ARCHITECTURE behavior OF tb_control IS

    -- Signals to connect with the control unit
    SIGNAL clk, rst_n, zero : std_ulogic := '0';
    SIGNAL instr_31_26 : std_ulogic_vector(5 downto 0) := (others => '0');
    SIGNAL instr_15_0 : std_ulogic_vector(15 downto 0) := (others => '0');
    
    SIGNAL ALUopcode : std_ulogic_vector(2 downto 0);
    SIGNAL RegDst, RegWrite, ALUSrcA, MemRead, MemWrite, MemtoReg, IorD, IRWrite : std_ulogic;
    SIGNAL ALUSrcB, PCSource : std_ulogic_vector(1 downto 0);
    SIGNAL PC_en : std_ulogic;

BEGIN

    -- Instantiate the unit under test (UUT)
    uut: ENTITY work.control
        PORT MAP (
            clk         => clk,
            rst_n       => rst_n,
            instr_31_26 => instr_31_26,
            instr_15_0  => instr_15_0,
            zero        => zero,
            ALUopcode   => ALUopcode,
            RegDst      => RegDst,
            RegWrite    => RegWrite,
            ALUSrcA     => ALUSrcA,
            MemRead     => MemRead,
            MemWrite    => MemWrite,
            MemtoReg    => MemtoReg,
            IorD        => IorD,
            IRWrite     => IRWrite,
            ALUSrcB     => ALUSrcB,
            PCSource    => PCSource,
            PC_en       => PC_en
        );

    -- Clock generation: 10ns period
    clk_process: PROCESS
    BEGIN
        WHILE true LOOP
            clk <= '0';
            WAIT FOR 5 ns;
            clk <= '1';
            WAIT FOR 5 ns;
        END LOOP;
    END PROCESS;

    -- Stimulus
    stim_proc: PROCESS
    BEGIN
        -- Reset
        rst_n <= '0';
        WAIT FOR 20 ns;
        rst_n <= '1';

        -- Instruction 1: LOAD word (opcode = 100011)
        instr_31_26 <= "100011";
        instr_15_0  <= (others => '0');
        zero        <= '0';
        WAIT FOR 100 ns;

        -- Instruction 2: R-type ADD (opcode = 000000, funct = 100000)
        instr_31_26 <= "000000";
        instr_15_0  <= x"0020";  -- funct = 100000 (add)
        zero        <= '0';
        WAIT FOR 100 ns;

        -- Instruction 3: BEQ (opcode = 000100)
        instr_31_26 <= "000100";
        instr_15_0  <= (others => '0');
        zero        <= '1'; -- simulate branch condition
        WAIT FOR 100 ns;

        -- Instruction 4: JUMP (opcode = 000010)
        instr_31_26 <= "000010";
        instr_15_0  <= (others => '0');
        WAIT FOR 100 ns;

        WAIT;
    END PROCESS;

END behavior;
