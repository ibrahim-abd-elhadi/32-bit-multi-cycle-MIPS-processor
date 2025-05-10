library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity MIPS is
  port (
    clk, rst, en : in std_logic
  );
end entity;

architecture behave of MIPS is

  component memory is
    port (
      clk        : in std_logic;
      addr       : in std_logic_vector(31 downto 0);
      write_en   : in std_logic;
      read_en    : in std_logic;
      write_data : in std_logic_vector(31 downto 0);
      read_data  : out std_logic_vector(31 downto 0)
    );
  end component;

  component controlfsm is
    port (
      clk, rst  : in std_logic;
      instr_31_26 : in std_logic_vector(5 downto 0);
      RegDst, RegWrite,
      ALUSrcA, MemRead,
      MemWrite, MemtoReg,
      IorD, IRWrite,
      PCWrite, PCWriteCond : out std_logic;
      ALUOp, ALUSrcB,
      PCSource : out std_logic_vector(1 downto 0)
    );
  end component;

  component ab_reg is
    port (
      clk       : in std_logic;
      reset   : in std_logic;
      in_A      : in std_logic_vector(31 downto 0);
      in_B      : in std_logic_vector(31 downto 0);
      in_ALUout : in std_logic_vector(31 downto 0);

      out_A      : out std_logic_vector(31 downto 0);
      out_B      : out std_logic_vector(31 downto 0);
      out_ALUout : out std_logic_vector(31 downto 0)
    );
  end component;

  component alu is
    port (
      input_1     : in std_logic_vector(31 downto 0);
      input_2     : in std_logic_vector(31 downto 0);
      ALU_control : in std_logic_vector(3 downto 0);

      result : out std_logic_vector(31 downto 0);
      zero   : out std_logic
    );
  end component;

  component aluout is
    port (
      input  : in std_logic_vector(31 downto 0);
      output : out std_logic_vector(31 downto 0) := X"00000000";
      en     : in std_logic;
      reset  : in std_logic;
      clk    : in std_logic
    );
  end component;

  component alucontrol is
    port (
      instr_5_0 : in std_logic_vector(5 downto 0);
      ALUOp     : in std_logic_vector(1 downto 0);
      ALUopcode : out std_logic_vector(3 downto 0)
    );
  end component;

  component instrreg is
    port (
      clk            : in std_logic;
      reset          : in std_logic;
      IRWrite        : in std_logic;
      in_instruction : in std_logic_vector(31 downto 0);

      out_instruction : out std_logic_vector(31 downto 0)
    );
  end component;

  component memorydataregister is
    port (
      clk      : in std_logic;
      reset  : in std_logic;
      data_in  : in std_logic_vector(31 downto 0);
      data_out : out std_logic_vector(31 downto 0)
    );
  end component;

  component mux2_5 is
    port (
      input_1    : in std_logic_vector(4 downto 0);
      input_2    : in std_logic_vector(4 downto 0);
      mux_select : in std_logic;

      output : out std_logic_vector(4 downto 0)
    );
  end component;

  component mux2 is
    port (
      input_1    : in std_logic_vector(31 downto 0);
      input_2    : in std_logic_vector(31 downto 0);
      mux_select : in std_logic;
      output     : out std_logic_vector(31 downto 0)
    );
  end component;

  component mux4 is
    port (
      input_1    : in std_logic_vector(31 downto 0);
      input_2    : in std_logic_vector(31 downto 0);
      input_3    : in std_logic_vector(31 downto 0);
      input_4    : in std_logic_vector(31 downto 0);
      mux_select : in std_logic_vector(1 downto 0);

      output : out std_logic_vector(31 downto 0)
    );
  end component;

  component registers is
    port (
      clk           : in std_logic;
      reset         : in std_logic; 
      address_in_1  : in std_logic_vector(4 downto 0);
      address_in_2  : in std_logic_vector(4 downto 0);
      write_address : in std_logic_vector(4 downto 0);
      data_in       : in std_logic_vector(31 downto 0);
      write_enable  : in std_logic;

      data_out_1 : out std_logic_vector(31 downto 0);
      data_out_2 : out std_logic_vector(31 downto 0)
    );
  end component;

  component pcreg is
    port (
      clk         : in std_logic;
      reset       : in std_logic;
      pc_in       : in std_logic_vector(31 downto 0);
      load_enable : in std_logic;
      pc_out      : out std_logic_vector(31 downto 0)
    );
  end component;

  component shiftleft2 is
    port (
      input : in std_logic_vector(25 downto 0);

      output : out std_logic_vector(27 downto 0)
    );
  end component;

  component signextend is
    port (
      input : in std_logic_vector(15 downto 0);

      output : out std_logic_vector(31 downto 0)
    );
  end component;

  component shiftleft is
    port (
      input : in std_logic_vector(31 downto 0);

      output : out std_logic_vector(31 downto 0)
    );
  end component;

  component mux3 is
    port (
      input_1    : in std_logic_vector(31 downto 0);
      input_2    : in std_logic_vector(31 downto 0);
      input_3    : in std_logic_vector(31 downto 0);
      mux_select : in std_logic_vector(1 downto 0);

      output : out std_logic_vector(31 downto 0)
    );
  end component;
  -- **********************************************
  -- signals :
  signal zero, RegDst, RegWrite, ALUSrcA, MemRead, MemWrite, MemtoReg, IorD, IRWrite, PCWrite, PCWriteCond, pc_en : std_logic;
  signal ALUSrcB, PCSource, ALUOp                                                                                 : std_logic_vector(1 downto 0);
  signal instruction, mem_address, mem_read_data, in_A, in_B, out_A, out_B, out_ALUout, alu_result, alu_input_1, alu_input_2, aluout_out,
  reg_write_data, mem_data_out, pc_out, s_e_out, sl32_to_mux, pc_in, jump_add : std_logic_vector (31 downto 0);
  signal ALU_control                                                          : std_logic_vector(3 downto 0);
  signal write_address                                                        : std_logic_vector(4 downto 0);
  signal sl28_to_mux                                                          : std_logic_vector(27 downto 0);

begin
  control_comp : controlfsm
  port map
  (
    clk, rst, instruction(31 downto 26),
    RegDst, RegWrite,
    ALUSrcA, MemRead,
    MemWrite, MemtoReg,
    IorD, IRWrite,
    PCWrite, PCWriteCond,
    ALUOp, ALUSrcB,
    PCSource
  );

  memory_comp : memory
  port map
  (
    clk, mem_address, MemWrite, MemRead, out_B, mem_read_data
  );
  ab_reg_comp : ab_reg
  port map
  (
    clk, rst, in_A, in_B, alu_result, out_A, out_B, out_ALUout
  );
  alu_comp : alu
  port map
  (
    alu_input_1, alu_input_2, ALU_control, alu_result, zero
  );
  aluout_comp : aluout
  port map
  (
    alu_result, aluout_out, en, rst, clk
  );
  alucontrol_comp : alucontrol
  port map
  (
    instruction (5 downto 0), ALUOp, ALU_control
  );
  instrreg_comp : instrreg
  port map
  (
    clk, rst, IRWrite, mem_read_data, instruction
  );
  memorydataregister_comp : memorydataregister
  port map
  (
    clk, rst, mem_read_data, mem_data_out
  );
  mux2_5_comp : mux2_5
  port map
  (
    instruction(20 downto 16), instruction(15 downto 11),
    RegDst, write_address
  );
  mux2_comp_0 : mux2
  port map
  (
    pc_out, aluout_out,
    IorD, mem_address
  );
  mux2_comp_1 : mux2
  port map
  (
    aluout_out, mem_data_out, MemtoReg, reg_write_data
  );
  mux2_comp_2 : mux2
  port map
  (
    pc_out, out_A, ALUSrcA, alu_input_1
  );
  mux4_comp : mux4
  port map
  (
    out_B, x"00000004", s_e_out, sl32_to_mux,
    ALUSrcB, alu_input_2
  );
  registers_comp : registers
  port map
  (
    clk, rst, instruction(25 downto 21), instruction(20 downto 16), write_address,
    reg_write_data, en, in_A, in_B
  );
  pc_en <= ((zero and PCWriteCond) or PCWrite);
  pcreg_comp : pcreg
  port map
  (
    clk, rst, pc_in, pc_en, pc_out
  );

  s_l_component : shiftleft2
  port map
  (
    instruction(25 downto 0), sl28_to_mux
  );

  signextend_comp : signextend
  port map
  (
    instruction(15 downto 0), s_e_out
  );

  s_l_comp : shiftleft
  port map
  (
    s_e_out, sl32_to_mux
  );
  jump_add <= pc_out(31 downto 28) & sl28_to_mux;
  mux3_comp : mux3
  port map
  (
    alu_result, aluout_out, jump_add, PCSource, pc_in
  );
end architecture;