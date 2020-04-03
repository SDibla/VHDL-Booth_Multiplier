library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use WORK.constants.all;

entity MULTIPLIER_tb is
end MULTIPLIER_tb;


architecture TEST of MULTIPLIER_tb is


  constant numBit : integer := NumBit;    -- :=8  -- :=16 -- :=32  

  --  input	 
  signal A_mp_i : std_logic_vector(numBit-1 downto 0) := (others => '0');
  signal B_mp_i : std_logic_vector(numBit-1 downto 0) := (others => '0');

  -- output
  signal Y_mp_i : std_logic_vector(2*numBit-1 downto 0);


-- MUL component declaration
	component BOOTHMUL
		generic (NBIT: integer := NumBit);
		port (a: in std_logic_vector(NBIT-1 downto 0); -- multiplicand
				b: in std_logic_vector(NBIT-1 downto 0); -- multiplier
				p: out std_logic_vector(2*NBIT-1 downto 0)); -- result
	end component;


begin

-- MUL instantiation
	
	MUL: BOOTHMUL port map(A_mp_i, B_mp_i,Y_mp_i);


-- PROCESS FOR TESTING TEST - COMLETE CYCLE ---------
  test: process
  begin

    -- cycle for operand A
    NumROW : for i in 0 to 2**(NumBit)-1 loop

    -- cycle for operand B
		NumCOL : for i in 0 to 2**(NumBit)-1 loop
			wait for 10 ns;
			B_mp_i <= B_mp_i + '1';
		end loop NumCOL ;
        
		A_mp_i <= A_mp_i + '1'; 	
    end loop NumROW ;

    wait;          
  end process test;

end TEST;
