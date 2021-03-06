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
			AN  : out STD_LOGIC_VECTOR (3 downto 0);
			LED : out STD_LOGIC_VECTOR (7 downto 0)
	 );
end FinalBehavior;

architecture Behavioral of FinalBehavior is
	 --signal s0  : STD_LOGIC_VECTOR (3 downto 0) := "0000"; --F
    signal RA  : STD_LOGIC_VECTOR (7 downto 0); --A
	 signal RB  : STD_LOGIC_VECTOR (7 downto 0); --C
 	 signal op  : STD_LOGIC_VECTOR (3 downto 0); --C
	 signal tmp  : STD_LOGIC_VECTOR (3 downto 0); --C
	 signal tmp2  : STD_LOGIC_VECTOR (7 downto 0); --C
	 signal rslt: STD_LOGIC_VECTOR (7 downto 0); --C
	 signal output_1: STD_LOGIC_VECTOR (7 downto 0);
	 signal output_2: STD_LOGIC_VECTOR (7 downto 0);
	 signal s3  : STD_LOGIC_VECTOR (3 downto 0) := "1110"; --E
    signal enl : STD_LOGIC := '1';
    signal dpc : STD_LOGIC_VECTOR (3 downto 0) := "1111";
    signal cen : STD_LOGIC := '0';
	 signal switch: STD_LOGIC := '0';
	 signal buttons: STD_LOGIC_VECTOR (3 downto 0) := "0000";
	 signal flag: STD_LOGIC := '0';
	 
begin
	LED(7 downto 4) <= tmp;
	
	switching: process (buttons(3), buttons(2),buttons(1),CLK,buttons(0))
	begin
		if(CLK'event and CLK = '1') then
			if (buttons(3) = '1' or buttons(2) = '1') then
				switch <= '0';
			end if;
			
			
			
			if(buttons(1) = '1') then
				switch <= '1';
			end if;
		end if;
		
		if (buttons(0) = '1' and flag = '0') then
				flag <= '1';
				switch <= not switch;
		end if;
		
		if (buttons(0) = '0') then
			flag <= '0';
		end if;
		
	end process;

	store_1: process (buttons(3), CLK)
    begin
        if (CLK'event and CLK = '1' and buttons(3) = '1') then
            RA <= SW(7 downto 0);
        end if;
    end process;
	 
	 store_2: process (buttons(2), CLK)
    begin
        if (CLK'event and CLK = '1' and buttons(2) = '1') then
            RB <= SW(7 downto 0);
        end if;
    end process;
	 
	 operate: process (buttons(1), CLK)
    begin
        if (CLK'event and CLK = '1' and buttons(1) = '1') then
            op <= SW(3 downto 0);
        end if;
    end process;
	 
	 with switch select
        output_1 <=
            RA     	when '0',   
            "0000"&op				when '1',
				RA 		when others;
				
	with switch select
        output_2 <=
            RB     	when '0',   
            rslt     when '1',
				RB 		when others;
	 
	ALU: entity work.ALU
	port map (
			  CLK  		=>	CLK,
           RA     	=> RA,
           RB    		=> RB,
           OPCODE    => op,
           CCR    	=> LED(3 downto 0),
           ALU_OUT   =>	rslt,
           LDST_OUT  => tmp2
				);
	
	SSeg: entity work.SSegDriver
	port map(  CLK     => CLK,
              RST     => cen,
              EN      => enl,
              SEG_0   => output_1(7 downto 4),
              SEG_1   => output_1(3 downto 0),
              SEG_2   => output_2(7 downto 4),
              SEG_3   => output_2(3 downto 0),
              DP_CTRL => dpc,
              COL_EN  => cen,
              SEG_OUT => SEG,
              DP_OUT  => DP,
              AN_OUT  => AN
				  );

	button_control: entity work.buttoncontrol
	port map ( CLK     => CLK,
           SW      => enl,
           BTN  	 => BTN,
           LED 	 => buttons
			  );
			
end Behavioral;

