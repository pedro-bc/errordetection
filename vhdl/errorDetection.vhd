----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    10:37:25 02/24/2015 
-- Design Name: 
-- Module Name:    errorDetection - Behavioral 
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
use work.DigEng.ALL;
--use IEEE.conv_pkg.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity errorDetection is
	GENERIC ( detectionSize : natural := 256;
				 countSize : natural := 8);
	PORT(
		clk : in STD_LOGIC;
		reset : in STD_LOGIC;
		errorFlag : out STD_LOGIC;
		errorCount : out STD_LOGIC_VECTOR(countSize-1 downto 0));
end errorDetection;

architecture Behavioral of errorDetection is

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
	 
	 COMPONENT counterSampler is
		 Generic( size : natural := 8);
		 Port ( clk : in  STD_LOGIC;
				  clear : in  STD_LOGIC;
				  enable : in STD_LOGIC;
				  Q : out  STD_LOGIC_VECTOR (size-1 downto 0));
	 end COMPONENT;
	 
	constant N : natural := 16;
	
	signal modA : std_logic_vector(N-1 downto 0) := (others => '0');
	signal modB : std_logic_vector(N-1 downto 0) := (others => '0');
	
	--signal modularOR : std_logic_vector(2*N-1 downto 0) := (others => '0');
	
	-- Inputs
	signal A : std_logic_vector(N-1 downto 0);
	signal B : std_logic_vector(N-1 downto 0);
	
	--Stage 1
	signal residueA : std_logic_vector(log2(detectionSize-1)-1 downto 0) := (others => '0');
	signal residueB : std_logic_vector(log2(detectionSize-1)-1 downto 0) := (others => '0');
	
	signal multA : std_logic_vector(N-1 downto 0) := (others => '0');
	signal multB : std_logic_vector(N-1 downto 0) := (others => '0');
	
	-- Stage 2	
	signal residueMult : std_logic_vector(2*log2(detectionSize-1)-1 downto 0) := (others => '0');	
	signal multQ : std_logic_vector(2*N-1 downto 0) := (others => '0');
	
	-- Stage 3
	signal residueMult_ff : std_logic_vector(2*log2(detectionSize-1)-1 downto 0) := (others => '0');
	signal multQ_ff : std_logic_vector(2*N-1 downto 0) := (others => '0');
	signal modQ : std_logic_vector(2*N-1 downto 0) := (others => '0');
	signal modResidues : std_logic_vector(2*log2(detectionSize-1)-1 downto 0) := (others => '0');
	
	-- Stage 4
	signal modQ_ff : std_logic_vector(log2(detectionSize-1)-1 downto 0) := (others => '0');
	signal modResidues_ff : std_logic_vector(log2(detectionSize-1)-1 downto 0) := (others => '0');
	
	signal compare : std_logic_vector(log2(detectionSize-1)-1 downto 0) := (others => '0');
	signal flagGen : std_logic := '0';

	-- Other
	signal sampleCount : std_logic_vector(countSize-1 downto 0);
	signal errCount : std_logic_vector(countSize-1 downto 0);
	
	signal takeSample : std_logic := '0';
	
begin

	-- Instantiate the Unit Under Test (UUT)
   uut0: lfsr 
	GENERIC MAP(N=>16)	
	PORT MAP (
          clk => clk,
          reset => reset,
			 polynome => X"F2AA",
          lfsr_out => A
        );
		  
	uut1: lfsr 
	GENERIC MAP(N=>16)	
	PORT MAP (
          clk => clk,
          reset => reset,
			 polynome => X"F431",
          lfsr_out => B
        );
		  
	count0 : counterSampler
	GENERIC MAP(size=>countSize)
	PORT MAP(
			clk => clk,
			enable => '1',
			clear => takeSample,
			Q => sampleCount
		);
				
	countErr : counterSampler
	GENERIC MAP(size=>countSize)
	PORT MAP(
			clk => clk,
			enable => residueMult_ff(1),
			clear => takeSample,
			Q => errCount
		);
			
	process(clk)
	begin
		if(rising_edge(clk)) then
			-- Stage 1 to Stage 2
			residueA <= modA(log2(detectionSize-1)-1 downto 0);
			residueB <= modB(log2(detectionSize-1)-1 downto 0);
			
			multA <= A;
			multB <= B;
			
			-- Stage 2 to Stage 3
			residueMult_ff <= residueMult;
			multQ_ff <= multQ;
			
			-- Stage 3 to Stage 4
			modQ_ff <= modQ(log2(detectionSize-1)-1 downto 0);
			modResidues_ff <= modResidues(log2(detectionSize-1)-1 downto 0);
			
			-- Stage 4 to Output
			if(takeSample='1') then
				errorFlag <= flagGen;
			end if;

			-- Sampling
			if(sampleCount = (sampleCount'range => '1')) then
				takeSample <= '1';
				errorCount <= errCount;
			else
				takeSample <= '0';
			end if;
		end if;
	end process;
	
	-- Stage 1
	modA <= std_logic_vector(unsigned(A) mod detectionSize);
	modB <= std_logic_vector(unsigned(B) mod detectionSize);
	
	-- Stage 2
	multQ <= std_logic_vector(unsigned(multA)*unsigned(multB));
	residueMult <= std_logic_vector(unsigned(residueA)*unsigned(residueB));
	
	-- Stage 3
	modResidues <= std_logic_vector(unsigned(residueMult_ff) mod detectionSize);
	modQ <= std_logic_vector(unsigned(multQ_ff) mod detectionSize);
	
	-- Stage 4
	f1: for i in 0 to (log2(detectionSize-1)-1) generate
		compare(i) <= modQ_ff(i) xor modResidues_ff(i);
	end generate;
	
	flagGen <= '0' when (compare = (compare'range => '0')) else '1';
	
end Behavioral;