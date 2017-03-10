library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;

entity reg_parallel_load_inc is
	generic (n: integer :=8);
	port(
		clock : in std_logic ;
		reset : in std_logic ;
		load : in std_logic ;
		inc : in std_logic ;
		data_in : std_logic_vector(n-1 downto 0);
		data_out : buffer std_logic_vector(n-1 downto 0)
	);
end reg_parallel_load_inc;


architecture behavior of reg_parallel_load_inc is
begin 
	pro_flag: process(reset,clock)
	begin
		if reset = '1' then -- Asynchronous reset 
			data_out <= (others=>'0');
		elsif rising_edge(clock) then 
			
			if load = '1' then
				data_out <= data_in ;
			elsif inc = '1' then
				data_out <= data_out + 1 ;
			end if;
		end if;
	end process;
end behavior;