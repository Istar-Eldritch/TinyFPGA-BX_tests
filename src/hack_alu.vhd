library ieee;
use ieee.numeric_std.all;
use ieee.std_logic_1164.all;

entity hack_alu is
  port(
    x: in signed(15 downto 0);
    y: in signed(15 downto 0);
    zx: in boolean;
    nx: in boolean;
    zy: in boolean;
    ny: in boolean;
    f: in boolean;
    no: in boolean;
    output: out signed(15 downto 0);
    zr: out boolean;
    ng: out boolean 
  );
end hack_alu;

architecture hack_alu_rtl of hack_alu is
  constant ZERO: signed(15 downto 0) := x"0000";
  signal zroedx: signed(15 downto 0);
  signal negedx: signed(15 downto 0); 
  signal zroedy: signed(15 downto 0);
  signal negedy: signed(15 downto 0); 
  signal oped: signed(15 downto 0);
  signal noed: signed(15 downto 0);
begin
  zroedx <= ZERO when zx else x;
  negedx <= not zroedx when nx else zroedx;

  zroedy <= ZERO when zy else y;
  negedy <= not zroedy when ny else zroedy;

  oped <= negedx + negedy when f else negedx and negedy;

  noed <= not oped when no else oped;

  output <= noed;
  zr <= noed = 0;
  ng <= noed < 0;
end hack_alu_rtl;

library ieee;
use ieee.numeric_std.all;
use ieee.std_logic_1164.all;

entity hack_alu_tb is
end hack_alu_tb;

architecture hack_alu_tb_arch of hack_alu_tb is
  signal x, y, output: signed(15 downto 0) := to_signed(0, 16);
  signal zx,nx,zy,ny,f,no, zr, ng: boolean := false;
begin
  alu_0: entity work.hack_alu port map(x => x, y => y, zx => zx, nx => nx, zy => zy, ny => ny, f => f, no => no, output => output, zr => zr, ng => ng);

  process
    type pattern_type is record
      x, y: signed(15 downto 0);
      zx,nx,zy,ny,f,no: boolean;
      output: signed(15 downto 0);
      zr,ng: boolean;
    end record;
    type pattern_array is array (natural range<>) of pattern_type;

    constant patterns : pattern_array := (
      -- 0
      (to_signed(0,16), to_signed(0,16), false,false,false,false,false,false, to_signed(0,16), true, false),
      (to_signed(1,16), to_signed(0,16), true,false,true,false,true,false, to_signed(0,16), true, false),
      (to_signed(1,16), to_signed(1,16), true,false,true,false,true,false, to_signed(0,16), true, false),
      (to_signed(0,16), to_signed(1,16), true,false,true,false,true,false, to_signed(0,16), true, false),
      (to_signed(-1,16), to_signed(0,16), true,false,true,false,true,false, to_signed(0,16), true, false),
      (to_signed(-1,16), to_signed(-1,16), true,false,true,false,true,false, to_signed(0,16), true, false),
      (to_signed(0,16), to_signed(-1,16), true,false,true,false,true,false, to_signed(0,16), true, false),

      -- 1
      (to_signed(0,16), to_signed(0,16), true,true,true,true,true,true, to_signed(1,16), false, false),
      (to_signed(1,16), to_signed(0,16), true,true,true,true,true,true, to_signed(1,16), false, false),
      (to_signed(1,16), to_signed(1,16), true,true,true,true,true,true, to_signed(1,16), false, false),
      (to_signed(0,16), to_signed(1,16), true,true,true,true,true,true, to_signed(1,16), false, false),
      (to_signed(-1,16), to_signed(0,16), true,true,true,true,true,true, to_signed(1,16), false, false),
      (to_signed(-1,16), to_signed(-1,16), true,true,true,true,true,true, to_signed(1,16), false, false),
      (to_signed(0,16), to_signed(-1,16), true,true,true,true,true,true, to_signed(1,16), false, false),

      -- -1
      (to_signed(0,16), to_signed(0,16), true,true,true,false,true,false, to_signed(-1,16), false, true),
      (to_signed(1,16), to_signed(0,16), true,true,true,false,true,false, to_signed(-1,16), false, true),
      (to_signed(1,16), to_signed(1,16), true,true,true,false,true,false, to_signed(-1,16), false, true),
      (to_signed(0,16), to_signed(1,16), true,true,true,false,true,false, to_signed(-1,16), false, true),
      (to_signed(-1,16), to_signed(0,16), true,true,true,false,true,false, to_signed(-1,16), false, true),
      (to_signed(-1,16), to_signed(-1,16), true,true,true,false,true,false, to_signed(-1,16), false, true),
      (to_signed(0,16), to_signed(-1,16), true,true,true,false,true,false, to_signed(-1,16), false, true),

      -- x
      (to_signed(0,16), to_signed(0,16), false,false,true,true,false,false, to_signed(0,16), true, false),
      (to_signed(-1,16), to_signed(0,16), false,false,true,true,false,false, to_signed(-1,16), false, true),
      (to_signed(-2,16), to_signed(-1,16), false,false,true,true,false,false, to_signed(-2,16), false, true),
      (to_signed(1,16), to_signed(0,16), false,false,true,true,false,false, to_signed(1,16), false, false),
      (to_signed(243,16), to_signed(23,16), false,false,true,true,false,false, to_signed(243,16), false, false),

      -- y
      (to_signed(0,16), to_signed(0,16), true,true,false,false,false,false, to_signed(0,16), true, false),
      (to_signed(0,16), to_signed(-1,16), true,true,false,false,false,false, to_signed(-1,16), false, true),
      (to_signed(-2,16), to_signed(-3,16), true,true,false,false,false,false, to_signed(-3,16), false, true),
      (to_signed(0,16), to_signed(1,16), true,true,false,false,false,false, to_signed(1,16), false, false),
      (to_signed(23,16), to_signed(243,16), true,true,false,false,false,false, to_signed(243,16), false, false),

      -- !x
      (to_signed(16#0000#,16), to_signed(16#0000#,16), false,false,true,true,false,true, to_signed(16#FFFF#,16), false, true),
      (to_signed(16#FFFF#,16), to_signed(16#0000#,16), false,false,true,true,false,true, to_signed(16#0000#,16), true, false),
      (to_signed(2#1000000000000001#,16), to_signed(-1,16), false,false,true,true,false,true, to_signed(2#0111111111111110#,16), false, false),
      (to_signed(2#0111111111111110#,16), to_signed(-1,16), false,false,true,true,false,true, to_signed(2#1000000000000001#,16), false, true)
    );
  begin
    for i in patterns'range loop
      x <= patterns(i).x;
      y <= patterns(i).y;
      zx <= patterns(i).zx;
      nx <= patterns(i).nx;
      zy <= patterns(i).zy;
      ny <= patterns(i).ny;
      f <= patterns(i).f;
      no <= patterns(i).no;

      wait for 1 ns;

      assert output = patterns(i).output
        report "Unexpected output for pattern '" & natural'image(i) & "', expected '" & integer'image(to_integer(patterns(i).output)) & "' got '" & integer'image(to_integer(output)) & "'" severity error;

      assert zr = patterns(i).zr
        report "Unexpected zr for pattern '" & natural'image(i) & "', expected '" & boolean'image(patterns(i).zr) & "' got '" & boolean'image(zr) & "'" severity error;

      assert ng = patterns(i).ng
        report "Unexpected ng for pattern '" & natural'image(i) & "', expected '" & boolean'image(patterns(i).ng) & "' got '" & boolean'image(ng) & "'" severity error;

    end loop;

    assert false report "end of test" severity note;
    wait;
  end process;

end hack_alu_tb_arch;
