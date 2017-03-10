library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;

entity microsequencer is 

	port(
		IR: 	in std_logic_vector(1 downto 0);
		clock: 	in std_logic;
		mOP: 	out std_logic_vector(10 downto 0)
	);
end microsequencer;

architecture structure of microsequencer is
	
	component mux_2 is 
		generic(n: natural :=4);
		port(
			select_signal : in std_logic ;
			data_in0 : in std_logic_vector(n-1 downto 0);
			data_in1 : in std_logic_vector(n-1 downto 0);
			data_out : buffer std_logic_vector(n-1 downto 0)
		);
	end component;
	
	component my_micro_memory is 
		generic (address_n: integer := 4;data_n: integer := 16);
		port(
			address: 	in std_logic_vector(address_n-1 downto 0);
			clock: 		in std_logic;
			data: 		out std_logic_vector(data_n-1 downto 0)
		);
	end component;
	
	signal operation: std_logic_vector(3 downto 0);
	signal micro_addr: std_logic_vector(3 downto 0);
	signal mux_out: std_logic_vector(3 downto 0);
	signal sel: std_logic;
	signal micromemory_data: std_logic_vector(15 downto 0);
	
begin 
	
	mux: 		mux_2 port map (sel, micro_addr ,operation ,mux_out );
	micro_mem: 	my_micro_memory port map (mux_out, clock, micromemory_data);
	
	operation <= '1' & IR & '0' ; -- MAP 
	
	sel 		<= micromemory_data(15);
	mOP 		<= micromemory_data(14 downto 4);
	micro_addr	<= micromemory_data(3 downto 0);
	
end structure;


------------------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;

entity microsequencer_tb is
end microsequencer_tb;

architecture test of microsequencer_tb is 
	
	component microsequencer is
		port(
			IR: 	in std_logic_vector(1 downto 0);
			clock: 	in std_logic;
			mOP: 	out std_logic_vector(10 downto 0)
		);
	end component;
	
	signal instruction: std_logic_vector(1 downto 0) := "00" ; -- 00:ADD , 01:AND , 10:JMP , 11:INC
	signal clock:std_logic := '0';
	signal microcode: std_logic_vector(10 downto 0);
	
begin 
	
	clock <= NOT clock after 50 ns;
	
	comp_flag: microsequencer port map(instruction, clock, microcode);
	
end test; 
