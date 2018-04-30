----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    15:24:08 04/19/2018 
-- Design Name: 
-- Module Name:    debouncer_verification - Behavioral 
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

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity debouncer_verification is
    Port (
           inRST : in  STD_LOGIC;
           inBUTT : in  STD_LOGIC;
           oLED_DATA : out  STD_LOGIC_VECTOR (7 downto 0));
end debouncer_verification;

architecture Behavioral of debouncer_verification is

begin

	process (inRST, inBUTT) begin
		if (inRST = '0') then 
			oLED_DATA <= (others => '0');
		elsif (inBUTT = '0') then
			oLED_DATA <= (others => '1');
		else 	
			oLED_DATA <= (others => '0');
		end if;
	end process;	

end Behavioral;

