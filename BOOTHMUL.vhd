library ieee;
use ieee.std_logic_1164.all;
use WORK.constants.all;

entity BOOTHMUL is 
	generic (NBIT: integer:=NumBit);
	  port (a: in std_logic_vector(NBIT-1 downto 0); -- multiplicand
			  b: in std_logic_vector(NBIT-1 downto 0); -- multiplier
			  p: out std_logic_vector(2*NBIT-1 downto 0)); -- result
end BOOTHMUL;

architecture behavior of BOOTHMUL is

	component booth_add 
		generic (NBIT: integer:=NumBit);
		port (a: in std_logic_vector(NBIT-1 downto 0); -- multiplicand
				b: in std_logic_vector(2 downto 0);  -- Booth multiplier
				sum_in: in std_logic_vector(NBIT-1 downto 0); -- sum input
				sum_out: out std_logic_vector(NBIT-1 downto 0); -- sum output
				p: out std_logic_vector(1 downto 0)); -- 2 bits of final result
	end component;
	
	signal start : std_logic_vector(NBIT-1 downto 0); -- start sum value
	signal mul0: std_logic_vector(2 downto 0); -- start 3 bit x algorithm (Booth multiplier)
	type sum_array is array(0 to (NBIT/2)-1) of std_logic_vector(NBIT-1 downto 0);
	signal sum : sum_array; -- partial sums signals

	begin 
	
		start <= (others => '0'); -- start sum value is all 0s
		
		mul0 <= b(1 downto 0) & '0'; --set first parameter of algorithm with first 2 bit of b and 0 
  
		ADDER0:  booth_add port map(a, mul0, start, sum(0), p(1 downto 0)); -- first adder/encoder/mux
  
		ADDER: for i in 1 to (NBIT/2)-2 generate 
			BOOTHADD:  booth_add port map(a, b((1+2*i) downto (2*i-1)), sum(i-1), sum(i), p((1+2*i) downto (2*i)));
		end generate;
  
		ADDERN: booth_add port map(a, b(NBIT-1 downto NBIT-3), sum((NBIT/2)-2), p(2*NBIT-1 downto NBIT), p(NBIT-1 downto NBIT-2)); -- last adder/encoder/mux

end behavior;  