library ieee;
use ieee.std_logic_1164.all;
use WORK.constants.all;

entity booth_add is
	generic (NBIT: integer:=NumBit);
	port (a: in  std_logic_vector(NBIT-1 downto 0); -- multiplicand
			b: in  std_logic_vector(2 downto 0);  -- Booth multiplier
			sum_in: in  std_logic_vector(NBIT-1 downto 0); -- sum input
			sum_out: out std_logic_vector(NBIT-1 downto 0); -- sum output
			p: out std_logic_vector(1 downto 0)); -- 2 bits of final result
end entity booth_add;

architecture behavior of booth_add is

	component  addsub_generic 
	generic (NBIT: integer:=NumBit);
	port(	a : in std_logic_vector(NBIT-1 DOWNTO 0); 
			b : in std_logic_vector(NBIT-1 DOWNTO 0);
			addsub : in std_LOGIC;
			sum : out std_logic_vector(NBIT-1 DOWNTO 0);
			cout: out std_logic);
	end component;

	
	component fa
		Port(	A:	In	std_logic;
				B:	In	std_logic;
				Ci: In std_logic;
				S:	Out std_logic;
				Co: Out std_logic);
	end component;
  
  signal not_a: std_logic_vector(NBIT-1 downto 0);
  signal a2: std_logic_vector(NBIT-1 downto 0);
  signal mux_out: std_logic_vector(NBIT-1 downto 0);
  signal psum: std_logic_vector(NBIT-1 downto 0);
  signal cout: std_logic;
  signal addsubs: std_logic;
  signal msb: std_logic;
  signal msb_out: std_logic;
  signal cout2: std_logic;
  
begin 
 
  a2 <= a(NBIT-2 downto 0) & '0'; -- shift left by 1 (x2)
  not_a <= not a; -- A complemented
 
-- MUX 3 to 1 with encoder 
	mux_out <= a when b="001" or b="010" or b="101" or b="110"           
        else a2 when b="011" or b="100"        
        else (others => '0');

-- ADD/SUB decider		  
	addsubs <= '1' when b="100" or b="101" or b="110" 
        else '0';
		  
-- FA entry			
	msb <= a(NBIT-1) when b="001" or b="010" or b="011"
            else not_a(NBIT-1) when b="100" or b="101" or b="110"
            else '0';

	ADDSUB: addsub_generic  port map(sum_in, mux_out, addsubs, psum, cout);
	FULLADDER: fa port map(sum_in(NBIT-1), msb, cout, msb_out, cout2); --used to take care of the last bit

	sum_out(NBIT-3 downto 0) <= psum(NBIT-1 downto 2); -- input for next sum
	sum_out(NBIT-2) <= msb_out; -- msb-1 for next sum
	sum_out(NBIT-1) <= msb_out; -- msb for next sum
	  
	p <= psum(1 downto 0); -- 2 bit of final result
  
end behavior;  