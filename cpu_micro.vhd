library ieee;
library work;
use ieee.std_logic_1164.all;
use work.cpu_pack.all ;

entity cpu_micro is
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
end cpu_micro;


architecture structure of cpu_micro is
	
	-- structure of microinstruction[15:0] : SEL[15] & mOP[14:4] & ADDR[3:0]
	
	-- mOP[10:0]
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
	
	signal PDM: std_logic_vector(2 downto 0); 	-- DATA BUS select  between PC , DATA_REG ,MEMORY : (PDM)
	
	signal memory_data: std_logic_vector(7 downto 0);
	signal ALU_output: std_logic_vector(7 downto 0);
	
begin
	
	MEMBUS 	<= mOP(0); -- same as READ
	DRBUS 	<= mOP(1);
	PCBUS 	<= mOP(2);
	ALUSEL 	<= mOP(3);
	IRLOAD 	<= mOP(4);
	ACINC 	<= mOP(5);
	ACLOAD 	<= mOP(6);
	DRLOAD 	<= mOP(7);
	PCINC 	<= mOP(8);
	PCLOAD 	<= mOP(9);
	ARLOAD 	<= mOP(10);
	
	PDM <= PCBUS & DRBUS & MEMBUS ; -- DATA BUS SEL	001 => MEMORY , 
												--	010 => DATA_REG , 
												--	100 => "00"&PC
	tag_databus: data_bus port map(memory_data, DR_out, PC_out, PDM, DataBus);
	
	tag_micro: microsequencer port map( DataBus(7 downto 6), clock , mOP );
	tag_main_memory: my_main_memory port map( DataBus(5 downto 0), clock, memory_data ); 	-- Main Memory in Architecture of Very Simple CPU has no clock , it works like a Look Up Table (LUT)
																							-- Therefore circumvention of AR Register for addressing the Main memory and the Register for addressing the micromemory is necessary

	tag_AR: reg_parallel_load generic map(6) port map(clock, reset, ARLOAD, DataBus(5 downto 0), AR_out);
	tag_IR: reg_parallel_load generic map(2) port map(clock, reset, IRLOAD, DataBus(7 downto 6), IR_out);
	tag_DR: reg_parallel_load port map(clock, reset, DRLOAD, DataBus, DR_out);
	
	tag_PC: reg_parallel_load_inc generic map(6) port map(clock, reset, PCLOAD, PCINC, DataBus(5 downto 0), PC_out );
	tag_AC: reg_parallel_load_inc port map(clock, reset, ACLOAD, ACINC, ALU_output, AC_out);
	
	tag_ALU: ALU port map(ALUSEL, DataBus, AC_out, ALU_output);
	
	
end structure;



------------------------------------------------------------------------------------------------------------------------------------------------------
--------------------------------------------------------TEST BENCHMARK OF CPU-------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;

entity test_cpu_micro is
end test_cpu_micro;

architecture structure of test_cpu_micro is
	
	component cpu_micro is
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
	
	comp_flag: cpu_micro port map(t_clock, t_reset, t_AR_out, t_PC_out, t_DR_out, t_AC_out, t_IR_out, t_DataBus, t_mOP);
	
	t_clock <= not t_clock after 20 ns;
	
	sim_pro: process
	begin
		wait for 10 ns;
		t_reset <= '1';
		
		wait for 5 ns;
		t_reset <= '0'; 
		
		
		wait;
	end process;
	
	
end structure;










