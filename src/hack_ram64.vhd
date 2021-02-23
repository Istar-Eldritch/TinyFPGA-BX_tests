library ieee;
use ieee.numeric_std.all;
use ieee.std_logic_1164.all;



entity RAM4K is
  port (
    clk: in std_logic;
    input: in std_logic_vector(11 downto 0);
    address: in integer range 0 to 4095;
    load: in boolean;
    output: out std_logic_vector(11 downto 0)
  );
end RAM4K;

architecture RAM4K_arch of RAM4K is
  type MEM4K is array (0 to 12287) of std_logic_vector(3 downto 0);
  signal mem: MEM4K := (others => (others => '0'));
  signal buff: std_logic_vector(11 downto 0);
begin

  write: process (clk) is
  begin
    if rising_edge(clk) then
      if load then
        mem(address) <= input(11 downto 8);
        mem(address + 1) <= input(7 downto 4);
        mem(address + 2) <= input(3 downto 0);
      end if;

      buff(11 downto 8) <= mem(address);
      buff(7 downto 4) <= mem(address + 1);
      buff(3 downto 0) <= mem(address + 2);

    end if;

  end process write;
end RAM4K_arch;

-- IO Map
library ieee;
use ieee.numeric_std.all;
use ieee.std_logic_1164.all;

entity IOMap is
  port (
    clk: in std_logic;
    input: in std_logic_vector(11 downto 0);
    address: in integer range 0 to 1;
    load: in boolean;
    output: out std_logic_vector(11 downto 0);

    PIN_1: inout std_logic;
    PIN_2: inout std_logic;
    PIN_3: inout std_logic;
    PIN_4: inout std_logic;
    PIN_5: inout std_logic;
    PIN_6: inout std_logic;
    PIN_7: inout std_logic;
    PIN_8: inout std_logic;

    PIN_9: inout std_logic;
    PIN_10: inout std_logic;
    PIN_11: inout std_logic;
    PIN_12: inout std_logic;
    PIN_13: inout std_logic;
    PIN_14: inout std_logic;
    PIN_15: inout std_logic;
    PIN_16: inout std_logic;

    PIN_17: inout std_logic;
    PIN_18: inout std_logic;
    PIN_19: inout std_logic;
    PIN_20: inout std_logic;
    PIN_21: inout std_logic;
    PIN_22: inout std_logic;
    PIN_23: inout std_logic;
    PIN_24: inout std_logic
  );
end IOMap;

architecture IOMap_arch of IOMap is
  signal mem: std_logic_vector(11 downto 0);
begin

  process (clk)
  begin
    if rising_edge(clk) then
      if load then
        if address = 0 then
          PIN_1 <= input(0);
          PIN_2 <= input(1);
          PIN_3 <= input(2);
          PIN_4 <= input(3);
          PIN_5 <= input(4);
          PIN_6 <= input(5);
          PIN_7 <= input(6);
          PIN_8 <= input(7);
          PIN_9 <= input(8);
          PIN_10 <= input(9);
          PIN_11 <= input(10);
          PIN_12 <= input(11);
        else
          PIN_13 <= input(0);
          PIN_14 <= input(1);
          PIN_15 <= input(2);
          PIN_16 <= input(3);
          PIN_17 <= input(4);
          PIN_18 <= input(5);
          PIN_19 <= input(6);
          PIN_20 <= input(7);
          PIN_21 <= input(8);
          PIN_22 <= input(9);
          PIN_23 <= input(10);
          PIN_24 <= input(11);

        end if;
      else
        if address = 0 then
          PIN_1 <= 'Z';
          PIN_2 <= 'Z';
          PIN_3 <= 'Z';
          PIN_4 <= 'Z';
          PIN_5 <= 'Z';
          PIN_6 <= 'Z';
          PIN_7 <= 'Z';
          PIN_8 <= 'Z';
          PIN_9 <= 'Z';
          PIN_10 <= 'Z';
          PIN_11 <= 'Z';
          PIN_12 <= 'Z';
        else
          PIN_13 <= 'Z';
          PIN_14 <= 'Z';
          PIN_15 <= 'Z';
          PIN_16 <= 'Z';
          PIN_17 <= 'Z';
          PIN_18 <= 'Z';
          PIN_19 <= 'Z';
          PIN_20 <= 'Z';
          PIN_21 <= 'Z';
          PIN_22 <= 'Z';
          PIN_23 <= 'Z';
          PIN_24 <= 'Z';
        end if;
      end if;

      if address = 0 then
        mem(0) <= PIN_1;
        mem(1) <= PIN_2;
        mem(2) <= PIN_3;
        mem(3) <= PIN_4;
        mem(4) <= PIN_5;
        mem(5) <= PIN_6;
        mem(6) <= PIN_7;
        mem(7) <= PIN_8;
        mem(8) <= PIN_9;
        mem(9) <= PIN_10;
        mem(10) <= PIN_11;
        mem(11) <= PIN_12;
      else
        mem(0) <= PIN_13;
        mem(1) <= PIN_14;
        mem(2) <= PIN_15;
        mem(3) <= PIN_16;
        mem(4) <= PIN_17;
        mem(5) <= PIN_18;
        mem(6) <= PIN_19;
        mem(7) <= PIN_20;
        mem(8) <= PIN_21;
        mem(9) <= PIN_22;
        mem(10) <= PIN_23;
        mem(11) <= PIN_24;
      end if;

      output <= mem;
    end if;
  end process;
end IOMap_arch;

-- Memory
-- ROM

library ieee;
use ieee.numeric_std.all;
use ieee.std_logic_1164.all;
use std.textio.all;
use ieee.std_logic_textio.all;

entity ROM4K is
  port (
    clk: in std_logic;
    address: in integer range 0 to 4095;
    output: out std_logic_vector(11 downto 0)
  );
end ROM4K;

architecture ROM4K_arch of ROM4K is
  type MEM4K is array (0 to 12287) of std_logic_vector(3 downto 0);
  impure function init_ram_hex return MEM4K is
    file file_pointer : text open read_mode is "program.bin";
    variable mem_index: integer := 0;
    variable mem_content: MEM4K;
    variable line_content: line;
    variable can_read: boolean := true;
    variable chunk: std_logic_vector(11 downto 0) := x"000";
    variable chunk_len: integer range 0 to 12 := 0;
  begin
    while not endfile(file_pointer) loop
      readline(file_pointer, line_content);
      hread(line_content, chunk);
    end loop;

    file_close(file_pointer);
    return mem_content;
  end function;

  signal mem: MEM4K := init_ram_hex;
begin

  readmem: process (clk) is
    variable buff: std_logic_vector(11 downto 0) := x"000";
  begin
    if rising_edge(clk) then
      buff(11 downto 8) := mem(address);
      buff(7 downto 4) := mem(address + 1);
      buff(3 downto 0) := mem(address + 2);
      output <= buff;
    end if;

  end process readmem;
end ROM4K_arch;
