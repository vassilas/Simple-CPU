library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;

entity adder_parallel is 
	generic (n: natural :=8);
	port(
		carry_in : in std_logic ;
		carry_out : out std_logic ;
		data_in_A : in std_logic_vector(n-1 downto 0);
		data_in_B : in std_logic_vector(n-1 downto 0);
		data_out : buffer std_logic_vector(n-1 downto 0)
	);
end adder_parallel;

architecture structure of adder_parallel is
	signal result: std_logic_vector(n downto 0);
begin
	result <= conv_std_logic_vector( conv_integer(data_in_A) + conv_integer(data_in_B) + conv_integer(carry_in) , n+1) ;
	data_out <= result(n-1 downto 0);
	carry_out <= result(n);
end structure ;