-- This circuit blinks the board led when there is an active signal on PIN_24

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity blink is
  port (
    CLK : in std_logic; -- 16MHz clock
    PIN_24 : in std_logic;
    LED : out std_logic
  );
end blink;



architecture rtl of blink is
  constant LED_OUTPUT : natural := 100;

  type t_Memory is array (0 to 63) of std_logic_vector(7 downto 0);
  -- The number of ticks of the clock in 1Hz
  constant c_CNT_1HZ  : natural := 16000000;
  signal r_CNT_1HZ  : natural range 0 to  c_CNT_1HZ;

  signal one : std_logic := '1';
  signal led_on : std_logic := '0';
  signal r_Mem : t_Memory;
begin


  r_Mem <=  (others => (others => '0'));

  blink : process (CLK) is
  begin
    if rising_edge(CLK) then
      if r_CNT_1HZ = c_CNT_1HZ - 1 then
        r_CNT_1HZ <= 0;
        led_on <= not led_on and PIN_24;
      else
        led_on <= led_on and PIN_24;
        r_CNT_1HZ <= r_CNT_1HZ + 1;
      end if;
    end if;
  end process blink;

  LED <= led_on;

end rtl;
