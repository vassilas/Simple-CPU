library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;


entity adder_CLA is 
	
	generic (n: integer :=4);
	port(
		carry_in : in std_logic ;
		carry_out : out std_logic ;
		
		data_in_A : in std_logic_vector(n-1 downto 0);
		data_in_B : in std_logic_vector(n-1 downto 0);
		
		data_out : buffer std_logic_vector(n-1 downto 0)
	);
	
end adder_CLA;



architecture structure of adder_CLA is

signal temp_sum : std_logic_vector(n-1 downto 0);
signal carry_generate : std_logic_vector(n-1 downto 0);
signal carry_propagate : std_logic_vector(n-1 downto 0);
signal carry_in_internal : std_logic_vector(n-1 downto 1);

begin
	
	temp_sum <= data_in_A XOR data_in_B ;
	carry_generate <= data_in_A AND data_in_B ;
	carry_propagate <= data_in_A OR data_in_B ;
	
	pro_flag : process(carry_generate,carry_propagate,carry_in_internal)
	begin
		carry_in_internal(1) <= carry_generate(0) OR ( carry_propagate(0) AND carry_in );
		
		for_flag : for i in 1 to n-2 
		loop
			carry_in_internal(i+1) <= carry_generate(i) OR ( carry_propagate(i) AND carry_in_internal(i) );
		end loop;
		
		carry_out <= carry_generate(n-1) OR ( carry_propagate(n-1) AND carry_in_internal(n-1) );
		
	end process;
	
	data_out(0) <= temp_sum(0) XOR carry_in ;
	data_out(n-1 downto 1) <= temp_sum(n-1 downto 1) XOR carry_in_internal(n-1 downto 1);
	
	
end structure ;


----------------TEST BENCH-------------------
library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;

entity adder_CLA_tb is
	generic (n: integer :=8);
end adder_CLA_tb;

architecture test of adder_CLA_tb is
	
	component adder_CLA is
		generic (n: integer :=4);
		port(
			carry_in : in std_logic ;
			carry_out : out std_logic ;
			data_in_A : in std_logic_vector(n-1 downto 0);
			data_in_B : in std_logic_vector(n-1 downto 0);
			data_out : buffer std_logic_vector(n-1 downto 0)
		);
	end component;
	
	signal c_in: std_logic := '0' ;
	signal c_out: std_logic;
	signal a_in: std_logic_vector(n-1 downto 0);
	signal b_in: std_logic_vector(n-1 downto 0);
	signal sum: std_logic_vector(n-1 downto 0);
	
begin
	
	comp_flag: adder_CLA generic map(8) port map(c_in ,
												 c_out ,
												 a_in ,
												 b_in ,
												 sum   );
	
	sim_pro: process
	begin
	a_in <= "00000010";
	b_in <= "01000010";
	
	wait for 50 ns;
	a_in <= "10000010";
	b_in <= "11000000";
	
	wait for 100 ns;
	a_in <= "00000011";
	b_in <= "01000011";
	
	wait for 150 ns;
	a_in <= "00000011";
	b_in <= "01001101";
	
	wait;
	end process;
	
end test ;












