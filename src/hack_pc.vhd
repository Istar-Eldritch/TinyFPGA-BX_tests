library ieee;
use ieee.numeric_std.all;
use ieee.std_logic_1164.all;

entity hack_pc is
  port(
    clk: in std_logic;
    input: in integer range 0 to 4095; -- 16bit int
    inc, load, reset: in boolean;
    output: out integer range 0 to 4095
  );
end hack_pc;

architecture hack_pc_rtl of hack_pc is
begin

  evaluate: process (clk) is

    variable count: integer range 0 to 4095 := 0; -- 16bit int
  begin
    if rising_edge(clk) then
      if reset then
        count := 0;
      end if;
      if load then
        count := input;
      end if;
      if inc then
        count := count + 1;
      end if;
    end if;
    output <= count;
  end process evaluate;
end hack_pc_rtl;


library ieee;
use ieee.numeric_std.all;
use ieee.std_logic_1164.all;

entity hack_pc_tb is
end hack_pc_tb;

architecture hack_pc_tb_behav of hack_pc_tb is
  constant CLOCK_PERIOD: time := 40 ns;
  signal inc, load, reset: boolean := false;
  signal clk: std_logic := '0';
  signal input, output: integer range 0 to 4095;
begin

  pc_0: entity work.hack_pc port map (clk => clk, input => input, inc  => inc, load => load, reset => reset, output => output);


  clk_gen: process is
  begin
   wait for CLOCK_PERIOD/2;
   clk <= not clk;
  end process clk_gen;


  process
    type pattern_type is record
      -- inputs
      inc, load, reset: boolean;
      input: integer range 0 to 4095;
      -- output
      output: integer range 0 to 4095;
    end record;
    type pattern_array is array (natural range<>) of pattern_type;

    constant patterns : pattern_array := (
      (false, false, false, 0, 0),
      (false, false, true, 0, 0),
      (true, false, false, 0, 1),
      (true, false, false, 0, 2),
      (false, false, true, 0, 0),
      (true, false, false, 0, 1),
      (true, false, false, 0, 2),
      (true, false, true, 0, 1),
      (false, true, false, 20, 20),
      (true, false, false, 0, 21),
      (true, true, false, 50, 51)
    );

  begin
    
    for i in patterns'range loop
      inc <= patterns(i).inc;
      load <= patterns(i).load;
      reset <= patterns(i).reset;
      input <= patterns(i).input;
      wait until rising_edge(clk);

      -- wait one full clock cycle before checking the assertions, reset inputs to avoid affecting the next assertion
      inc <= false;
      load <= false;
      reset <= false;
      input <= 0;
      wait until rising_edge(clk);
      assert output = patterns(i).output
      report "Unexpected output for pattern '" & natural'image(i) & "', expected '" & natural'image(patterns(i).output) & "' but got '" & natural'image(output) & "'" severity error;
    end loop;

    assert false report "end of test" severity note;
    wait;
  end process;
end hack_pc_tb_behav;



