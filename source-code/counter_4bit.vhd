library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;

entity counter_4bit is 
	port(
		data_in : in std_logic_vector(3 downto 0); -- In CPU the Input will be '1' & IR[1:0] & '0' 
		
		load : in std_logic ;
		inc : in std_logic ;
		reset : in std_logic ;
		clock : in std_logic ;
		
		data_out : buffer std_logic_vector(3 downto 0)
	);
end counter_4bit ;

architecture structure of counter_4bit is 
begin 
	
	pro_flag: process(reset,clock)
	begin
		if rising_edge(clock) then 
			if reset = '1' then
				data_out <= "0000";
			elsif load = '1' then 
				data_out <= data_in ;
			elsif inc = '1' then 
				data_out <= data_out + 1 ;
			
			end if;
		end if;
		
	end process;
	

end structure;



------------------------------------------------------------------------------------------------------------------------------------------------------
--------------------------------------------------------TEST BENCHMARK OF COUNTER---------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------------------------------


library ieee;
use ieee.std_logic_1164.all;

entity test_counter_4bit is
end test_counter_4bit;

architecture structure of test_counter_4bit is 

	component counter_4bit is
		port(
			data_in : in std_logic_vector(3 downto 0);
			load : in std_logic ;
			inc : in std_logic ;
			reset : in std_logic ;
			clock : in std_logic ;
			data_out : buffer std_logic_vector(3 downto 0)
		);
	end component;
	
	signal data_in : std_logic_vector(3 downto 0) := "0000";
	signal load : std_logic := '1' ;
	signal inc : std_logic := '0' ;
	signal reset : std_logic := '0' ;
	signal clock : std_logic := '0' ;
	signal data_out : std_logic_vector(3 downto 0) ;

begin 
	
	comp_flag: counter_4bit port map(data_in,load,inc,reset,clock,data_out);
	
	clock_flag: process
	begin
		wait for 20 ns;
		clock <= NOT clock ;
	end process;
	
	pro_flag: process
	begin
		wait for 105 ns;
		load <= '0';
		inc <= '1';
		reset <= '0';
		
	end process;
	
end;









