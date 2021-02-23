library ieee;
use ieee.numeric_std.all;
use ieee.std_logic_1164.all;


entity hack_cpu is
  port(
    clk: in std_logic;
    inM: in std_logic_vector(15 downto 0);
    instruction: in std_logic_vector(15 downto 0);
    reset: in boolean;
    outM: out std_logic_vector(15 downto 0);
    pc, addressM: out std_logic_vector(5 downto 0);
    writeM: out boolean
  );
end hack_cpu;

architecture hack_cpu_rtl of hack_cpu is

begin

end hack_cpu_rtl;
