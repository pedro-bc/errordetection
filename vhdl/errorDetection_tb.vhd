--------------------------------------------------------------------------------
-- Company: 
-- Engineer:
--
-- Create Date:   11:50:30 02/24/2015
-- Design Name:   
-- Module Name:   /media/extraHDD/ecgberht/Graceful/project/errorLogger/errorDetection_tb.vhd
-- Project Name:  errorLogger
-- Target Device:  
-- Tool versions:  
-- Description:   
-- 
-- VHDL Test Bench Created by ISE for module: errorDetection
-- 
-- Dependencies:
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
--
-- Notes: 
-- This testbench has been automatically generated using types std_logic and
-- std_logic_vector for the ports of the unit under test.  Xilinx recommends
-- that these types always be used for the top-level I/O of a design in order
-- to guarantee that the testbench will bind correctly to the post-implementation 
-- simulation model.
--------------------------------------------------------------------------------
LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE work.DigEng.ALL;
 
-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--USE ieee.numeric_std.ALL;
 
ENTITY errorDetection_tb IS
END errorDetection_tb;
 
ARCHITECTURE behavior OF errorDetection_tb IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT errorDetection
	 GENERIC(
			detectionSize : natural := 256;
			countSize : natural := 8);
    PORT(
         clk : IN  std_logic;
         reset : IN  std_logic;
			errorFlag : OUT std_logic;
         errorCount : OUT  std_logic_vector(countSize-1 downto 0)
        );
    END COMPONENT;
    
	constant detectionSize : natural := 256;
	constant countSize : natural := 4;

   --Inputs
   signal clk : std_logic := '0';
   signal reset : std_logic := '0';

 	--Outputs
   signal errorCount : std_logic_vector(countSize-1 downto 0);
	signal errorFlag : std_logic;

   -- Clock period definitions
   constant clk_period : time := 10 ns;
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: errorDetection 
	GENERIC MAP(
			 detectionSize => 256,
			 countSize => 4)
	
	PORT MAP (
          clk => clk,
          reset => reset,
			 errorFlag => errorFlag,
          errorCount => errorCount
        );

   -- Clock process definitions
   clk_process :process
   begin
		clk <= '0';
		wait for clk_period/2;
		clk <= '1';
		wait for clk_period/2;
   end process;
 

   -- Stimulus process
   stim_proc: process
   begin		
      -- hold reset state for 100 ns.
		reset <= '1';
      wait for 100 ns;
		reset <= '0';

      wait for clk_period*10;

      -- insert stimulus here 

      wait;
   end process;

END;
