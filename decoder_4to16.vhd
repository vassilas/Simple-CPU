library ieee;
use ieee.std_logic_1164.all;


entity decoder_4to16 is
	port(
		input: in std_logic_vector(3 downto 0);
		output: buffer std_logic_vector(15 downto 0)
	);
end decoder_4to16;


architecture structure of decoder_4to16 is
begin
	        -- MSBit . . . . . LSBit --
	output <= 	"0000000000000001" when input <= "0000" else
				"0000000000000010" when input <= "0001" else
				"0000000000000100" when input <= "0010" else
				"0000000000001000" when input <= "0011" else
				"0000000000010000" when input <= "0100" else
				"0000000000100000" when input <= "0101" else
				"0000000001000000" when input <= "0110" else
				"0000000010000000" when input <= "0111" else
				"0000000100000000" when input <= "1000" else
				"0000001000000000" when input <= "1001" else
				"0000010000000000" when input <= "1010" else
				"0000100000000000" when input <= "1011" else
				"0001000000000000" when input <= "1100" else
				"0010000000000000" when input <= "1101" else
				"0100000000000000" when input <= "1110" else
				"1000000000000000" when input <= "1111" ;

end structure;


-------------- TEST BENCH -----------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;

entity dec_4to16_tb is
end dec_4to16_tb;

architecture structure of dec_4to16_tb is

	component decoder_4to16 is 
	port(
		input: in std_logic_vector(3 downto 0);
		output: buffer std_logic_vector(15 downto 0)
	);
	end component;
	
	signal dec_in: std_logic_vector(3 downto 0) := "0000" ;
	signal dec_out: std_logic_vector(15 downto 0);
	
begin
	
	comp_flag: decoder_4to16 port map( dec_in, dec_out);
	
	dec_in <= dec_in + 1 after 20 ns ;
	
	
end structure;