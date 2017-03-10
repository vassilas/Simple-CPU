library ieee;
use ieee.std_logic_1164.all;

entity data_bus is
	port(
		Memory_out: in std_logic_vector(7 downto 0);
		DataReg_out: in std_logic_vector(7 downto 0); 
		PC_out: in std_logic_vector(5 downto 0); 
		PDM : in std_logic_vector(2 downto 0); 	
		-- DATA BUS select  between PC , DATA_REG ,MEMORY : (PDM)
		-- DATA BUS SEL	001 => MEMORY , 
		--				010 => DATA_REG , 
		--				100 => "00"&PC
		DataBus: out std_logic_vector(7 downto 0)
	);
end data_bus;

architecture structure of data_bus is
begin

	DataBus <= 	Memory_out 		when PDM = "001"  	else 
				DataReg_out 	when PDM = "010" 	else
				"00" & PC_out	when PDM = "100" 	else "00000000";
	
end structure ;


------------------------------------------------------------------------------------------------------------------------------------------------------
--------------------------------------------------------TEST BENCHMARK OF DATA_BUS--------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;

entity test_data_bus is
end test_data_bus;

architecture structure of test_data_bus is 
	
	component data_bus is
		port(
			Memory_out: in std_logic_vector(7 downto 0);
			DataReg_out: in std_logic_vector(7 downto 0); 
			PC_out: in std_logic_vector(5 downto 0); 
			PDM : in std_logic_vector(2 downto 0);
			DataBus: out std_logic_vector(7 downto 0)
		);
	end component;
	
	signal MEM : std_logic_vector(7 downto 0) := conv_std_logic_vector(0,8);
	signal DR : std_logic_vector(7 downto 0) := conv_std_logic_vector(0,8);
	signal PC : std_logic_vector(5 downto 0) := conv_std_logic_vector(0,6);
	signal SEL : std_logic_vector(2 downto 0) := "001";
	signal BUS_OUT : std_logic_vector(7 downto 0);
	
begin
	
	comp_flagL: data_bus port map(MEM, DR, PC, SEL, BUS_OUT);
	
	sim_proc: process
	begin
		
		wait for 100 ns;
		MEM <= conv_std_logic_vector(55,8);
		DR <= conv_std_logic_vector(23,8);
		PC <= conv_std_logic_vector(31,6);
		SEL <= "001" ;
		
		wait for 100 ns;
		MEM <= conv_std_logic_vector(63,8);
		DR <= conv_std_logic_vector(23,8);
		PC <= conv_std_logic_vector(31,6);
		SEL <= "100" ;
		
		wait for 100 ns;
		MEM <= conv_std_logic_vector(63,8);
		DR <= conv_std_logic_vector(64,8);
		PC <= conv_std_logic_vector(31,6);
		SEL <= "001" ;
		
		wait for 100 ns;
		MEM <= conv_std_logic_vector(63,8);
		DR <= conv_std_logic_vector(64,8);
		PC <= conv_std_logic_vector(31,6);
		SEL <= "010" ;
		
		wait for 100 ns;
		MEM <= conv_std_logic_vector(63,8);
		DR <= conv_std_logic_vector(64,8);
		PC <= conv_std_logic_vector(31,6);
		SEL <= "000" ;
		
		
	end process;
	
end;
	
	
