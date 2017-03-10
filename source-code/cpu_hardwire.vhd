library ieee;
library work;
use ieee.std_logic_1164.all;
use work.cpu_pack.all ;

entity cpu_hardwire is
	port(
		clock: 		in std_logic;
		reset: 		in std_logic;
		
		AR_out:		buffer std_logic_vector( 5 downto 0 );
		PC_out:		buffer std_logic_vector( 5 downto 0 );
		DR_out: 	buffer std_logic_vector( 7 downto 0 );
		AC_out: 	buffer std_logic_vector( 7 downto 0 );
		IR_out: 	buffer std_logic_vector( 1 downto 0 );
		
		DataBus:	buffer std_logic_vector( 7 downto 0 );
		mOP: 		buffer std_logic_vector( 10 downto 0 )
	);
end cpu_hardwire;

architecture structure of cpu_hardwire is
	
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
	
	signal counter_load, counter_inc, counter_clr: std_logic ; -- Counter Control Signals
	signal counter_out: std_logic_vector(3 downto 0);
	
	signal decoder_out: std_logic_vector(15 downto 0);
	signal counter_reset: std_logic;
	
	signal FETCH1: std_logic ;
	signal FETCH2: std_logic ;
	signal FETCH3: std_logic ;
	signal ADD1: std_logic ;
	signal ADD2: std_logic ;
	signal AND1: std_logic ;
	signal AND2: std_logic ;
	signal JMP1: std_logic ;
	signal INC1: std_logic ;
	
	signal PDM: std_logic_vector(2 downto 0); 	-- DATA BUS select  between PC , DATA_REG ,MEMORY : (PDM)
	
	signal memory_data: std_logic_vector(7 downto 0);
	signal ALU_output: std_logic_vector(7 downto 0);
	
	signal counter_input: std_logic_vector(3 downto 0);
	
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
	
	
	counter_reset <= counter_clr OR reset ;
	counter_load <= FETCH3 ;
	counter_inc <= FETCH1 OR FETCH2 OR ADD1 OR AND1 ;
	counter_clr <= ADD2 OR AND2 OR JMP1 OR INC1 ;
	counter_input <= '1' & DataBus(7 downto 6) & '0' ;
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
	
	PDM <= PCBUS & DRBUS & MEMBUS ;
	databus_comp: data_bus port map(memory_data, DR_out, PC_out, PDM, DataBus);
	
	mainmemory_comp: my_main_memory port map(DataBus(5 downto 0), clock, memory_data);
	
	tag_AR: reg_parallel_load generic map(6) port map (clock, reset, ARLOAD, DataBus(5 downto 0), AR_out);
	tag_IR: reg_parallel_load generic map(2) port map(clock, reset, IRLOAD, DataBus(7 downto 6), IR_out);
	tag_DR: reg_parallel_load port map(clock, reset, DRLOAD, DataBus, DR_out);
	tag_PC: reg_parallel_load_inc generic map(6) port map(clock, reset, PCLOAD, PCINC, DataBus(5 downto 0), PC_out);
	tag_AC: reg_parallel_load_inc port map(clock, reset, ACLOAD, ACINC, ALU_output, AC_out);
	
	tag_ALU: ALU port map(ALUSEL, DataBus, AC_out, ALU_output);
	
end structure;


------------------------------------------------------------------------------------------------------------------------------------------------------
--------------------------------------------------------TEST BENCHMARK OF CPU-------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;

entity test_cpu_hardwire is
end test_cpu_hardwire;

architecture structure of test_cpu_hardwire is
	
	component cpu_hardwire is
		port(
			clock: 		in std_logic;
			reset: 		in std_logic;
			AR_out:		buffer std_logic_vector( 5 downto 0 );
			PC_out:		buffer std_logic_vector( 5 downto 0 );
			DR_out: 	buffer std_logic_vector( 7 downto 0 );
			AC_out: 	buffer std_logic_vector( 7 downto 0 );
			IR_out: 	buffer std_logic_vector( 1 downto 0 );
			DataBus:	buffer std_logic_vector( 7 downto 0 );
			mOP: 		buffer std_logic_vector( 10 downto 0 )
		);
	end component;
	
	signal t_clock: std_logic := '0';
	signal t_reset: std_logic := '0';
	
	signal t_AR_out: std_logic_vector(5 downto 0);
	signal t_PC_out: std_logic_vector(5 downto 0);
	signal t_DR_out: std_logic_vector(7 downto 0);
	signal t_AC_out: std_logic_vector(7 downto 0);
	signal t_IR_out: std_logic_vector(1 downto 0);
	
	signal t_DataBus: std_logic_vector(7 downto 0);
	signal t_mOP: std_logic_vector(10 downto 0);
	
begin 
	
	comp_flag: cpu_hardwire port map(t_clock, t_reset, t_AR_out, t_PC_out, t_DR_out, t_AC_out, t_IR_out, t_DataBus, t_mOP);
	
	t_clock <= not t_clock after 20 ns;
	
	sim_pro: process
	begin
		wait for 10 ns;
		t_reset <= '1';
		
		wait for 30 ns;
		t_reset <= '0'; 
		
		
		wait;
	end process;
	
	
end structure;