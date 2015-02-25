--------------------------------------------------------------------------------
-- Company: 
-- Engineer:
--
-- Create Date:   12:19:02 02/23/2015
-- Design Name:   
-- Module Name:   /media/extraHDD/ecgberht/Graceful/project/errorLogger/lfsr_tb.vhd
-- Project Name:  errorLogger
-- Target Device:  
-- Tool versions:  
-- Description:   
-- 
-- VHDL Test Bench Created by ISE for module: lfsr
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
USE ieee.numeric_std.ALL;
 
-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--USE ieee.numeric_std.ALL;
 
ENTITY lfsr_tb IS
END lfsr_tb;
 
ARCHITECTURE behavior OF lfsr_tb IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT lfsr
	 GENERIC(
			N : natural := 16);
    PORT(
         clk : IN  std_logic;
         reset : IN  std_logic;
			polynome : in STD_LOGIC_VECTOR(N-1 downto 0);
         lfsr_out : OUT  std_logic_vector(N-1 downto 0)
        );
    END COMPONENT;
    
	constant N : natural := 16;

   --Inputs
   signal clk : std_logic := '0';
   signal reset : std_logic := '0';
	
	signal A : std_logic_vector(7 downto 0) := X"03";
	signal B : std_logic_vector(7 downto 0) := X"02";
	
	signal C : std_logic_vector(31 downto 0) := X"FFFFFFFF";
	
	signal modC : std_logic_vector(31 downto 0) := (others => '0');
	signal modResult : std_logic_vector(31 downto 0) := (others => '0');
	signal modA : std_logic_vector(15 downto 0) := X"FFFF";
	signal modB : std_logic_vector(15 downto 0) := X"FFF0";
	
	--C <= A*B;

 	--Outputs
   signal lfsr0_out : std_logic_vector(N-1 downto 0);
	signal lfsr1_out : std_logic_vector(N-1 downto 0);

   -- Clock period definitions
   constant clk_period : time := 10 ps;
 
BEGIN

	C <= std_logic_vector(unsigned(lfsr0_out)*unsigned(lfsr1_out));
	
	modA <= std_logic_vector(unsigned(lfsr0_out) mod 8);
	modB <= std_logic_vector(unsigned(lfsr1_out) mod 8);
	modC <= std_logic_vector(unsigned(C) mod 8);
	
	modResult <= std_logic_vector((unsigned(modA)*unsigned(modB)) mod 8);
	
	--modResult <= std_logic_vector((unsigned(multMod) mod 8));
 
	-- Instantiate the Unit Under Test (UUT)
   uut0: lfsr 
	GENERIC MAP(N=>16)	
	PORT MAP (
          clk => clk,
          reset => reset,
			 polynome => X"F2AA",
          lfsr_out => lfsr0_out
        );
		  
	uut1: lfsr 
	GENERIC MAP(N=>16)	
	PORT MAP (
          clk => clk,
          reset => reset,
			 polynome => X"F431",
          lfsr_out => lfsr1_out
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
      wait for 100 ps;
		reset <= '0';
		
		A <= X"05";

      wait for clk_period*1000;

      -- insert stimulus here 

      wait;
   end process;

END;
