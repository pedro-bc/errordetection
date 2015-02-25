----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    12:17:43 02/23/2015 
-- Design Name: 
-- Module Name:    lfsr - Behavioral 
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

entity lfsr is
	 Generic ( N : natural := 16);
    Port ( clk : in  STD_LOGIC;
           reset : in  STD_LOGIC;
			  polynome : in STD_LOGIC_VECTOR(N-1 downto 0);
           lfsr_out : out  STD_LOGIC_VECTOR (N-1 downto 0));
end lfsr;

architecture Behavioral of lfsr is

	signal lfsr_tmp         	:std_logic_vector (N-1 downto 0):= (0=>'1',others=>'0');
 	--constant polynome		:std_logic_vector (N-1 downto 0):= "1011010000000000";
	
begin

 	process (clk, reset) 
		variable lsb		:std_logic;	 
 		variable ext_inbit	:std_logic_vector (N-1 downto 0) ;
	begin 
		lsb := lfsr_tmp(0);
		for i in 0 to N-1 loop
		    ext_inbit(i):= lsb; 
		end loop;
	if (reset = '1') then
		lfsr_tmp <= (0=>'1', others=>'0');
	elsif (rising_edge(clk)) then
		lfsr_tmp <= ( '0' & lfsr_tmp(N-1 downto 1) ) xor ( ext_inbit and polynome );
	end if;
	end process;
    	lfsr_out <= lfsr_tmp;
		
end Behavioral;

