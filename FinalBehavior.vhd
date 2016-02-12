----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    15:43:13 02/12/2016 
-- Design Name: 
-- Module Name:    FinalBehavior - Behavioral 
-- Project Name: 
-- Target Devices: 
-- Tool versions: 
-- Description: 
--
-- Dependencies: 
--
-- Revision: 
-- Revision 0.01 - File Created
-- Additional Comments: 
--
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use work.all;
-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity FinalBehavior is
	Port (CLK : in  STD_LOGIC; -- 50 MHz input
			SW  : in  STD_LOGIC_VECTOR (7 downto 0);
			BTN : in  STD_LOGIC_VECTOR (3 downto 0);
			SEG : out STD_LOGIC_VECTOR (6 downto 0);
			DP  : out STD_LOGIC;
			AN  : out STD_LOGIC_VECTOR (3 downto 0)
	 );
end FinalBehavior;

architecture Behavioral of FinalBehavior is
	 --signal s0  : STD_LOGIC_VECTOR (3 downto 0) := "0000"; --F
    signal RA  : STD_LOGIC_VECTOR (7 downto 0); --A
	 signal RB  : STD_LOGIC_VECTOR (7 downto 0); --C
    signal s3  : STD_LOGIC_VECTOR (3 downto 0) := "1110"; --E
    signal enl : STD_LOGIC := '1';
    signal dpc : STD_LOGIC_VECTOR (3 downto 0) := "1111";
    signal cen : STD_LOGIC := '0';
	 
begin
	
	reset: process (BTN(0),CLK)
	begin
        if (CLK'event and CLK = '1' and BTN(0) = '1') then
            RA <= "00000000";
				RB <= "00000000";
        end if;
    end process;
	 
	store_1: process (BTN(3), CLK)
    begin
        if (CLK'event and CLK = '1' and BTN(3) = '1') then
            RA <= SW(7 downto 0);
        end if;
    end process;
	 
	 store_2: process (BTN(2), CLK)
    begin
        if (CLK'event and CLK = '1' and BTN(2) = '1') then
            RB <= SW(7 downto 0);
        end if;
    end process;
	 
	SSeg: entity work.SSegDriver
	port map( CLK     => CLK,
              RST     => BTN(0),
              EN      => enl,
              SEG_0   => RA(7 downto 4),
              SEG_1   => RA(3 downto 0),
              SEG_2   => RB(7 downto 4),
              SEG_3   => RB(3 downto 0),
              DP_CTRL => dpc,
              COL_EN  => cen,
              SEG_OUT => SEG,
              DP_OUT  => DP,
              AN_OUT  => AN);


end Behavioral;

