library IEEE;
use IEEE.std_logic_1164.all;

entity PipelineReg is
    port(Inst : in std_logic_vector(31 downto 0);
        PC4 : in std_logic_vector(31 downto 0);
        Control : in std_logic_vector(15 downto 0);
        rd : in std_logic_vector(4 downto 0);
        rsd : in std_logic_vector(31 downto 0);
        rtd : in std_logic_vector(31 downto 0);
        imm : in std_logic_vector(31 downto 0);
        ALU : in std_logic_vector(31 downto 0);
        Dmem : in std_logic_vector(31 downto 0);
        clk : in std_logic;
        reset : in std_logic;
        o_Inst : out std_logic_vector(31 downto 0);
        o_PC4 : out std_logic_vector(31 downto 0);
        o_ex : out std_logic_vector(7 downto 0);
        o_shamt : out std_logic_vector(4 downto 0);
        o_rd : out std_logic_vector(4 downto 0);
        o_rsd_ex : out std_logic_vector(31 downto 0);
        o_rtd_ex : out std_logic_vector(31 downto 0);
        o_imm : out std_logic_vector(31 downto 0);
        o_ALU : out std_logic_vector(31 downto 0);
        o_Dmem : out std_logic_vector(31 downto 0));
end PipelineReg;

architecture structural of PipelineReg is
    
    component RegNBit is
        generic(N : integer := 32);
        port(clk : in std_logic;
            reset : in std_logic;
            we : in std_logic;
            data : in std_logic_vector(N-1 downto 0);
            o_data : out std_logic_vector(N-1 downto 0));
    end component;

    signal instruction : std_logic_vector(31 downto 0);
    signal memforward : std_logic;
    signal wbforward1 : std_logic_vector(6 downto 0);
    signal rdforward1 : std_logic_vector(4 downto 0);
    signal rsdforward1 : std_logic_vector(31 downto 0);
    signal rtdforward : std_logic_vector(31 downto 0);
    signal pc4forward1 : std_logic_vector(31 downto 0);
    signal pc4forward2 : std_logic_vector(31 downto 0);
begin
    
    --IF/ID
    IFID : RegNBit
    port MAP(clk => clk,
            reset => reset,
            we => '1',
            data => Inst,
            o_data => instruction);
    
    o_Inst <= instruction;

    --PC + 4
    PC4reg : RegNBit
    port MAP(clk => clk,
            reset => reset,
            we => '1',
            data => PC4,
            o_data => pc4forward1);

    o_PC4 <= pc4forward1;

    --ID/EX
    --EX controls
    EXControl : RegNBit
    generic MAP(N <= 8)
    port MAP(clk => clk,
            reset => reset,
            we => '1',
            data => Control(15 downto 8),
            o_data => o_ex);

    --MEM controls
    MEMControl : RegNBit
    generic MAP(N <= 1)
    port MAP(clk => clk,
            reset => reset,
            we => '1',
            data => Control(7),
            o_data => memforward);

    --WB controls
    WBControl : RegNBit
    generic MAP(N <= 7)
    port MAP(clk => clk,
            reset => reset,
            we => '1',
            data => Control(6 downto 0),
            o_data => wbforward1);
    
    --rd
    DestReg : RegNBit
    generic MAP(N <= 5)
    port MAP(clk => clk,
            reset => reset,
            we => '1',
            data => rd,
            o_data => rdforward1);
    
    --rs data
    rsData : RegNBit
    port MAP(clk => clk,
            reset => reset,
            we => '1',
            data => rsd,
            o_data => rsdforward1);
    
    o_rsd_ex <= rsdforward1;
    
    --rt data
    rtData : RegNBit
    port MAP(clk => clk,
            reset => reset,
            we => '1',
            data => rtd,
            o_data => rtdforward);
    
    o_rtd_ex <= rtdforward;

    --shamt
    ShiftAmt : RegNBit
    generic MAP(N <= 5)
    port MAP(clk => clk,
            reset => reset,
            we => '1',
            data => instruction(10 downto 6),
            o_data => o_shamt);

    --imm
    ImmData : RegNBit
    port MAP(clk => clk,
            reset => reset,
            we => '1',
            data => imm,
            o_data => o_imm);
    
    --PC + 4
    PC4reg : RegNBit
    port MAP(clk => clk,
            reset => reset,
            we => '1',
            data => pc4forward1,
            o_data => pc4forward2);
end structural;