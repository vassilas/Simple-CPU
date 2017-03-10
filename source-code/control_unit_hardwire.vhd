library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;


entity control_unit_hardwire is 

	port(
		IR: 	in std_logic_vector(1 downto 0);
		clock: 	in std_logic;
		mOP: 	out std_logic_vector(10 downto 0);
		
		reset: in std_logic
	);
	
end control_unit_hardwire;

architecture structure of control_unit_hardwire is 

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
	
	component decoder_4to16 is
		port(
		input: in std_logic_vector(3 downto 0);
		output: buffer std_logic_vector(15 downto 0)
		);
	end component;
	
	signal counter_load, counter_inc, counter_clr, counter_reset: std_logic ; -- Counter Control Signals
	signal counter_out: std_logic_vector(3 downto 0);
	signal decoder_out: std_logic_vector(15 downto 0);
	signal counter_input: std_logic_vector(3 downto 0);
	
	signal MEMBUS: std_logic ; -- mOP[0]  // Same signal with READ 
	signal DRBUS: std_logic ;-- mOP[1] 
	signal PCBUS: std_logic ;-- mOP[2] 
	signal ALUSEL: std_logic ;-- mOP[3] 
	signal IRLOAD: std_logic ;-- mOP[4] 
	signal ACINC: std_logic ;-- mOP[5] 
	signal ACLOAD: std_logic ;-- mOP[6] 
	signal DRLOAD: std_logic ;-- mOP[7] 
	signal PCINC: std_logic ;-- mOP[8] 
	signal PCLOAD: std_logic ;-- mOP[9] 
	signal ARLOAD: std_logic ;-- mOP[10] 
	
	signal FETCH1: std_logic ;
	signal FETCH2: std_logic ;
	signal FETCH3: std_logic ;
	signal ADD1: std_logic ;
	signal ADD2: std_logic ;
	signal AND1: std_logic ;
	signal AND2: std_logic ;
	signal JMP1: std_logic ;
	signal INC1: std_logic ;
	
begin
	
	FETCH1 	<= decoder_out(0);
	FETCH2 	<= decoder_out(1);
	FETCH3 	<= decoder_out(2);
	ADD1 	<= decoder_out(8);
	ADD2 	<= decoder_out(9);
	AND1 	<= decoder_out(10);
	AND2 	<= decoder_out(11);
	JMP1 	<= decoder_out(12);
	INC1 	<= decoder_out(14);
	
	
	counter_load <= FETCH3 ;
	counter_inc <= FETCH1 OR FETCH2 OR ADD1 OR AND1 ;
	counter_clr <= ADD2 OR AND2 OR JMP1 OR INC1 ;
	counter_input <= '1' & IR & '0' ;
	counter_reset <= counter_clr OR reset ;
	counter_comp: counter_4bit port map(counter_input ,counter_load ,counter_inc ,counter_reset ,clock, counter_out);
	decoder_comp: decoder_4to16 port map(counter_out, decoder_out);
	
	MEMBUS 	<= FETCH2 OR ADD1 OR AND1;
	DRBUS 	<= FETCH3 OR ADD2 OR AND2 OR JMP1 ;
	PCBUS 	<= FETCH1 ;
	ALUSEL	<= AND2 ;
	IRLOAD 	<= FETCH3 ;
	ACINC 	<= INC1 ;
	ACLOAD 	<= ADD2 OR AND2 ;
	DRLOAD 	<= FETCH2 OR ADD1 OR AND1 ;
	PCINC 	<= FETCH2 ;
	PCLOAD 	<= JMP1 ;
	ARLOAD 	<= FETCH1 OR FETCH3 ; 
	
	mOP(0) 	<= MEMBUS;
	mOP(1) 	<= DRBUS;
	mOP(2) 	<= PCBUS;
	mOP(3) 	<= ALUSEL;
	mOP(4) 	<= IRLOAD;
	mOP(5) 	<= ACINC;
	mOP(6) 	<= ACLOAD;
	mOP(7) 	<= DRLOAD;
	mOP(8) 	<= PCINC;
	mOP(9) 	<= PCLOAD;
	mOP(10) <= ARLOAD;
	
end structure ;


-- TEST BENCH
library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;

entity control_unit_hardwire_tb is
end control_unit_hardwire_tb;

architecture test of control_unit_hardwire_tb is
	
	component control_unit_hardwire
		port(
			IR: 	in std_logic_vector(1 downto 0);
			clock: 	in std_logic;
			mOP: 	out std_logic_vector(10 downto 0);
			
			reset: in std_logic
		);
	end component;
	
	signal instruction: std_logic_vector(1 downto 0) := "00" ; -- 00:ADD , 01:AND , 10:JMP , 11:INC
	signal clock:std_logic := '0';
	signal microcode: std_logic_vector(10 downto 0);
	signal counter_reset: std_logic := '0' ;

begin

	clock <= NOT clock after 50 ns;
	comp_flag: control_unit_hardwire port map(instruction, clock, microcode, counter_reset);
	
	sim_pro: process
	begin
		wait for 30 ns;
		counter_reset <= '1';
		
		wait for 30 ns;
		counter_reset <= '0'; 
		
		wait;
	end process;
	
end test ;
