-------------------------------------------------------------------------
-- Henry Duwe
-- Department of Electrical and Computer Engineering
-- Iowa State University
-------------------------------------------------------------------------


-- MIPS_Processor.vhd
-------------------------------------------------------------------------
-- DESCRIPTION: This file contains a skeleton of a MIPS_Processor  
-- implementation.

-- 01/29/2019 by H3::Design created.
-------------------------------------------------------------------------


library IEEE;
use IEEE.std_logic_1164.all;

library work;
use work.MIPS_types.all;

entity MIPS_Processor is
  generic(N : integer := DATA_WIDTH);
  port(iCLK            : in std_logic;
       iRST            : in std_logic;
       iInstLd         : in std_logic;
       iInstAddr       : in std_logic_vector(N-1 downto 0);
       iInstExt        : in std_logic_vector(N-1 downto 0);
       oALUOut         : out std_logic_vector(N-1 downto 0));

end  MIPS_Processor;


architecture structure of MIPS_Processor is

  -- Required data memory signals
  signal s_DMemWr       : std_logic;
  signal s_DMemAddr     : std_logic_vector(N-1 downto 0);
  signal s_DMemData     : std_logic_vector(N-1 downto 0);
  signal s_DMemOut      : std_logic_vector(N-1 downto 0);
 
  -- Required register file signals 
  signal s_RegWr        : std_logic;
  signal s_RegWrAddr    : std_logic_vector(4 downto 0);
  signal s_RegWrData    : std_logic_vector(N-1 downto 0);

  -- Required instruction memory signals
  signal s_IMemAddr     : std_logic_vector(N-1 downto 0); -- Do not assign this signal, assign to s_NextInstAddr instead
  signal s_NextInstAddr : std_logic_vector(N-1 downto 0);
  signal s_Inst         : std_logic_vector(N-1 downto 0);

  -- Required halt signal -- for simulation
  signal s_Halt         : std_logic;

  -- Required overflow signal -- for overflow exception detection
  signal s_Ovfl         : std_logic;

  component mem is
    generic(ADDR_WIDTH : integer;
            DATA_WIDTH : integer);
    port(
          clk          : in std_logic;
          addr         : in std_logic_vector((ADDR_WIDTH-1) downto 0);
          data         : in std_logic_vector((DATA_WIDTH-1) downto 0);
          we           : in std_logic := '1';
          q            : out std_logic_vector((DATA_WIDTH -1) downto 0));
    end component;

  component Control is
    port(opcode : in std_logic_vector(5 downto 0);
        funct : in std_logic_vector(5 downto 0);
        i_rd : in std_logic_vector(4 downto 0);
        o_rd : out std_logic_vector(4 downto 0);
        movz : out std_logic;
        movn : out std_logic;
        beq : out std_logic;
        bne : out std_logic;
        blez : out std_logic;
        bgtz : out std_logic;
        imm_ext : out std_logic;
        sel_y : out std_logic;
        rs_sel : out std_logic;
        ivu_sel : out std_logic;
        astype : out std_logic;
        shdir : out std_logic;
        alu_sel_2 : out std_logic;
        alu_sel_1 : out std_logic;
        alu_sel_0 : out std_logic;
        dmem_we : out std_logic;
        reg_we : out std_logic;
        reg_sel_1 : out std_logic;
        reg_sel_0 : out std_logic;
        rd_sel : out std_logic;
        pc_sel_1 : out std_logic;
        pc_sel_0 : out std_logic;
        det_o : out std_logic;
        halt : out std_logic);
  end component;

  component ALU is
    port(X : in std_logic_vector(31 downto 0);
        Y : in std_logic_vector(31 downto 0);
        astype : in std_logic;
        shamt : in std_logic_vector(4 downto 0);
        shdir : in std_logic;
        ivu_sel : in std_logic;
        alu_sel_0 : in std_logic;
        alu_sel_1 : in std_logic;
        alu_sel_2 : in std_logic;
        result : out std_logic_vector(31 downto 0);
        zero : out std_logic;
        negative : out std_logic;
        overflow : out std_logic);
  end component;

  component RegFile is
    port(data : in std_logic_vector(31 downto 0);
        i_rs : in std_logic_vector(4 downto 0);
        i_rt : in std_logic_vector(4 downto 0);
        i_rd : in std_logic_vector(4 downto 0);
        reset : in std_logic;
        clk : in std_logic;
        o_rs : out std_logic_vector(31 downto 0);
        o_rt : out std_logic_vector(31 downto 0));
  end component;

  component PC is
    port(linkr : in std_logic_vector(31 downto 0);
        JAddr : in std_logic_vector(25 downto 0);
        BAddr : in std_logic_vector(31 downto 0);
        pc_sel_1 : in std_logic;
        pc_sel_0 : in std_logic;
        clk : in std_logic;
        reset : in std_logic;
        halt : in std_logic;
        o_PC : out std_logic_vector(31 downto 0);
        o_PC4 : out std_logic_vector(31 downto 0));
  end component;

  component extend1632 is
    port(data : in std_logic_vector(15 downto 0);
        exttype : in std_logic;
        result : out std_logic_vector(31 downto 0));
  end component;

  signal o_rd : std_logic_vector(4 downto 0);
  signal movz : std_logic;
  signal movn : std_logic;
  signal beq : std_logic;
  signal bne : std_logic;
  signal blez : std_logic;
  signal bgtz : std_logic;
  signal imm_ext : std_logic;
  signal sel_y : std_logic;
  signal rs_sel : std_logic;
  signal ivu_sel : std_logic;
  signal astype : std_logic;
  signal shdir : std_logic;
  signal alu_sel_2 : std_logic;
  signal alu_sel_1 : std_logic;
  signal alu_sel_0 : std_logic;
  signal reg_we : std_logic;
  signal reg_sel_1 : std_logic;
  signal reg_sel_0 : std_logic;
  signal rd_sel : std_logic;
  signal pc_sel_1 : std_logic;
  signal pc_sel_0 : std_logic;
  signal det_o : std_logic;
  signal ext_res : std_logic_vector(31 downto 0);
  signal o_rs : std_logic_vector(31 downto 0);
  signal o_rt : std_logic_vector(31 downto 0);
  signal pc4o : std_logic_vector(31 downto 0);
  signal x : std_logic_vector(31 downto 0);
  signal y : std_logic_vector(31 downto 0);
  signal shamt : std_logic_vector(4 downto 0);
  signal z : std_logic;
  signal neg : std_logic;
  signal o : std_logic;
  signal pc_1 : std_logic;
  signal pc_0 : std_logic;
  signal reg_sel : std_logic_vector(1 downto 0);

begin

  -- TODO: This is required to be your final input to your instruction memory. This provides a feasible method to externally load the memory module which means that the synthesis tool must assume it knows nothing about the values stored in the instruction memory. If this is not included, much, if not all of the design is optimized out because the synthesis tool will believe the memory to be all zeros.
  with iInstLd select
    s_IMemAddr <= s_NextInstAddr when '0',
      iInstAddr when others;


  IMem: mem
    generic map(ADDR_WIDTH => ADDR_WIDTH,
                DATA_WIDTH => N)
    port map(clk  => iCLK,
             addr => s_IMemAddr(11 downto 2),
             data => iInstExt,
             we   => iInstLd,
             q    => s_Inst);
  
  DMem: mem
    generic map(ADDR_WIDTH => ADDR_WIDTH,
                DATA_WIDTH => N)
    port map(clk  => iCLK,
             addr => s_DMemAddr(11 downto 2),
             data => s_DMemData,
             we   => s_DMemWr,
             q    => s_DMemOut);

  -- TODO: Ensure that s_Halt is connected to an output control signal produced from decoding the Halt instruction (Opcode: 01 0100)
  -- TODO: Ensure that s_Ovfl is connected to the overflow output of your ALU

  -- TODO: Implement the rest of your processor below this comment! 
  Control0 : Control
  port MAP(opcode => s_Inst(31 downto 26),
          funct => s_Inst(5 downto 0),
          i_rd => s_Inst(15 downto 11),
          o_rd => o_rd,
          movz => movz,
          movn => movn,
          beq => beq,
          bne => bne,
          blez => blez,
          bgtz => bgtz,
          imm_ext => imm_ext,
          sel_y => sel_y,
          rs_sel => rs_sel,
          ivu_sel => ivu_sel,
          astype => astype,
          shdir => shdir,
          alu_sel_2 => alu_sel_2,
          alu_sel_1 => alu_sel_1,
          alu_sel_0 => alu_sel_0,
          dmem_we => s_DMemWr,
          reg_we => reg_we,
          reg_sel_1 => reg_sel_1,
          reg_sel_0 => reg_sel_0,
          rd_sel => rd_sel,
          pc_sel_1 => pc_sel_1,
          pc_sel_0 => pc_sel_0,
          det_o => det_o,
          halt => s_Halt);

  Extender: extend1632
  port MAP(data => s_Inst(15 downto 0),
          exttype => imm_ext,
          result => ext_res);
  
  reg : RegFile
  port MAP(data => s_RegWrData,
          i_rs => s_Inst(25 downto 21),
          i_rt => s_Inst(20 downto 16),
          i_rd => s_RegWrAddr,
          reset => iRST,
          clk => iCLK,
          o_rs => o_rs,
          o_rt => o_rt);

  s_DMemData <= o_rt;

  with rs_sel select
    x <= o_rs when '0',
         x"00000000" when others;

  with sel_y select
    y <= o_rt when '0',
         ext_res when '1',
         x"00000000" when others;

  with ivu_sel select
    shamt <= s_Inst(10 downto 6) when '0',
             o_rs(4 downto 0) when '1',
             "00000" when others;

  ALU0 : ALU
  port MAP(X => x,
          Y => y,
          astype => astype,
          shamt => shamt,
          shdir => shdir,
          ivu_sel => ivu_sel,
          alu_sel_0 => alu_sel_0,
          alu_sel_1 => alu_sel_1,
          alu_sel_2 => alu_sel_2,
          result => s_DMemAddr,
          zero => z,
          negative => neg,
          overflow => o);
  
  oALUOut <= s_DMemAddr;
  s_Ovfl <= o and det_o;
  pc_1 <= pc_sel_1 or (beq and z) or (bne and (not z)) or (blez and (z or (neg xor o))) or (bgtz and ((not z) and (not (neg xor o))));
  pc_0 <= pc_sel_0 or (beq and z) or (bne and (not z)) or (blez and (z or (neg xor o))) or (bgtz and ((not z) and (not (neg xor o))));

  progc : PC
  port MAP(linkr => o_rs,
          JAddr => s_Inst(25 downto 0),
          BAddr => ext_res,
          pc_sel_1 => pc_1,
          pc_sel_0 => pc_0,
          clk => iCLK,
          reset => iRST,
          halt => s_Halt,
          o_PC => s_NextInstAddr,
          o_PC4 => pc4o);
  
  s_RegWr <= reg_we or (movz and z) or (movn and (not z));

  s_RegWrAddr <= o_rd when (rd_sel = '0' and s_RegWr = '1') else
                 s_Inst(20 downto 16) when (rd_sel = '1' and s_RegWr = '1') else
                 "00000";
  
  reg_sel <= reg_sel_1 & reg_sel_0;

  with reg_sel select
    s_RegWrData <= s_DMemAddr when "00",
                   s_DMemOut when "01",
                   pc4o when "10",
                   o_rs when "11",
                   x"00000000" when others;
                   

end structure;

