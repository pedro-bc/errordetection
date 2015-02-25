----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    16:23:38 02/24/2015 
-- Design Name: 
-- Module Name:    counter - Behavioral 
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

entity counterSampler is
	 Generic( size : natural := 8);
    Port ( clk : in  STD_LOGIC;
           clear : in  STD_LOGIC;
			  enable : in STD_LOGIC;
           Q : out  STD_LOGIC_VECTOR (size-1 downto 0));
end counterSampler;

architecture Behavioral of counterSampler is

	signal tmp : std_logic_vector(size-1 downto 0) := (others => '0');

begin
	process(clk, clear)
	begin
		if (clear = '1') then
			tmp <= (others=>'0');
		elsif(rising_edge(clk)) then
			if(enable='1') then
				tmp <= std_logic_vector(unsigned(tmp) + 1);
			end if;
		end if;
	end process;
	Q <= tmp;
end Behavioral;

