library IEEE;
use IEEE.std_logic_1164.all;

entity PipelineReg is
    port(IFIDWe : in std_logic;
        Inst : in std_logic_vector(31 downto 0);
        PC4 : in std_logic_vector(31 downto 0);
        Control : in std_logic_vector(15 downto 0) --PC_en to Add
        rs : in std_logic_vector(4 downto 0);
        rt : in std_logic_vector(4 downto 0);
        rd : in std_logic_vector(4 downto 0);
        rsd : in std_logic_vector(31 downto 0);
        rtd : in std_logic_vector(31 downto 0);
        ALU : in std_logic_vector(31 downto 0);
        Dmem : in std_logic_vector(31 downto 0);
        o_Inst : out std_logic_vector(31 downto 0);
        o_PC4 : out std_logic_vector(31 downto 0);
        o_control : out std_logic_vector(31 downto 0);
        o_rs : out std_logic_vector(4 downto 0);
        o_rt : out std_logic_vector(4 downto 0);
        o_rd : out std_logic_vector(4 downto 0);
        o_rsd : out std_logic_vector(31 downto 0);
        o_rtd : out std_logic_vector(31 downto 0)
        o_ALU : out std_logic_vector(31 downto 0);
        o_Dmem : out std_logic_vector(31 downto 0));
end PipelineReg;