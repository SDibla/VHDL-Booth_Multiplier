library ieee;
use ieee.std_logic_1164.all;
use WORK.constants.all;

entity addsub_generic is --add a xor chain to RCA, implementing addition (0) or subtraction (1)
  generic (NBIT: integer:=NumBit);
  port(  a : in std_logic_vector(NBIT-1 downto 0); 
			b : in std_logic_vector(NBIT-1 downto 0);
			addsub : in std_logic;
			sum : out std_logic_vector(NBIT-1 downto 0);
			cout: out std_logic);
end addsub_generic;

architecture behavior of addsub_generic is 

	component rca_generic 
	generic (NBIT: integer:=NumBit);
	port (a:	In	std_logic_vector(NBIT-1 downto 0);
			b:	In	std_logic_vector(NBIT-1 downto 0);
			ci: In std_logic;
			s:	Out std_logic_vector(NBIT-1 downto 0);
			co: Out std_logic);
	end component;

	signal as: std_logic_vector(NBIT-1 downto 0);
	signal xorb: std_logic_vector(NBIT-1 downto 0);
	
	begin			 		
		as <= (others => addsub);
		xorb <= b XOR as; --xor between input B and Cin 
		ADDER: rca_generic port map(a, xorb, addsub, sum, cout);
			  
end behavior;