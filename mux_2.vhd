library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;


entity mux_2 is 
	
	generic (n: natural :=8);
	port(
		select_signal : in std_logic ;
		
		data_in0 : in std_logic_vector(n-1 downto 0);
		data_in1 : in std_logic_vector(n-1 downto 0);
		
		data_out : buffer std_logic_vector(n-1 downto 0)
	);
	
end mux_2;


architecture structure of mux_2 is
begin
	
	data_out <= data_in1 when(select_signal = '1') else data_in0 ;
	
end structure;