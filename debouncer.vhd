----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    12:37:24 04/19/2018 
-- Design Name: 
-- Module Name:    debouncer - Behavioral 
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
use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity debouncer is
	 Generic (
		 DEBOUNCE_PERIOD : integer := 48000
	 );
    Port ( iCLK 		: in  STD_LOGIC;
           inRST 		: in  STD_LOGIC;
           iBUTT 		: in  STD_LOGIC;
           oDEB_BUTT : out  STD_LOGIC);
end debouncer;

architecture Behavioral of debouncer is

	type 	 tSTATES is (IDLE, PUSHED_BUTTON, CHECK_BUTTON, RELEASED_BUTTON);   		-- Debouncer states
	signal sCURRENT_STATE, sNEXT_STATE : tSTATES;  											-- Debouncer next and current state
	
	signal sTC 	    		: std_logic;
	
	signal sDEB_CNT_EN	: std_logic;				   -- 
	
	
	signal sDEB_CNT 		: unsigned(15 downto 0); 
	

begin

	-- FSM state register process
	fsm_reg : process (iCLK, inRST) begin
		if (inRST = '0') then 
			sCURRENT_STATE <= IDLE; -- Reset FSM
		elsif (iCLK'event and iCLK = '1') then
			sCURRENT_STATE <= sNEXT_STATE; -- Move to next state
		end if;
	end process fsm_reg;
	
	-- FSM next state logic
	fsm_next : process (sCURRENT_STATE, iBUTT, sTC) begin
		case (sCURRENT_STATE) is 
			when IDLE   =>
				-- Wait for psuhed button
				if (iBUTT = '0') then
					sNEXT_STATE <= PUSHED_BUTTON;
				else 
					sNEXT_STATE <= IDLE;
				end if;
			when PUSHED_BUTTON =>
				-- Debounce period
				if (sTC = '1') then
					sNEXT_STATE <= CHECK_BUTTON;
				else 	
					sNEXT_STATE <= PUSHED_BUTTON;
				end if;
			when CHECK_BUTTON  =>
				-- Wait for released button
				if (iBUTT = '1') then
					sNEXT_STATE <= RELEASED_BUTTON;
				else 
					sNEXT_STATE <= CHECK_BUTTON;
				end if;
			when RELEASED_BUTTON =>
				-- Debounce period for released button
				if (sTC = '1') then
					sNEXT_STATE <= IDLE;
				else 	
					sNEXT_STATE <= RELEASED_BUTTON;
				end if;			
		end case;
	end process fsm_next;
	
	-- FSM output logic
	fsm_out : process (sCURRENT_STATE) begin
		case (sCURRENT_STATE) is
			when IDLE    			=>
				sDEB_CNT_EN <= '0';
				oDEB_BUTT   <= '1';
			when PUSHED_BUTTON   =>
				sDEB_CNT_EN <= '1';
				oDEB_BUTT 	<= '0';
			when CHECK_BUTTON 	=>
				sDEB_CNT_EN <= '0';
				oDEB_BUTT   <= '0';
			when RELEASED_BUTTON =>
				sDEB_CNT_EN <= '1';
				oDEB_BUTT   <= '1';
		end case;
	end process fsm_out;
	
	
	-- Debounce period counter
	deb_cnt : process (iCLK, inRST) begin
		if (inRST = '0') then
			sDEB_CNT <= (others => '0'); -- Reset counter
		elsif (iCLK'event and iCLK = '1') then
			if (sDEB_CNT = DEBOUNCE_PERIOD - 1) then
				sDEB_CNT <= (others => '0'); -- If debounce period done
			elsif (sDEB_CNT_EN = '1') then
				sDEB_CNT <= sDEB_CNT + 1;
			end if;
		end if;
	end process;
	
	-- Terminal count for debounced period
	sTC <= '1' when sDEB_CNT = DEBOUNCE_PERIOD - 1 else 
			 '0';
			 
			 
end Behavioral;

