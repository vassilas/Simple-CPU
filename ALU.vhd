library ieee;
use ieee.std_logic_1164.all;

entity ALU is 
	
	generic (n: natural :=8);
	port(
		alu_select_op :  in std_logic ;
		
		alu_data_in1 : in std_logic_vector(n-1 downto 0);
		alu_data_in2 : in std_logic_vector(n-1 downto 0);
		
		alu_data_out : buffer std_logic_vector(n-1 downto 0)
	);
	
end ALU;


architecture structure of ALU is
	
	component mux_2
		generic (n: natural :=8);
		port(
			select_signal : in std_logic ;
			data_in0 : in std_logic_vector(n-1 downto 0);
			data_in1 : in std_logic_vector(n-1 downto 0);
			data_out : buffer std_logic_vector(n-1 downto 0)
		);
	end component;
	
	component adder_parralel is 
		generic (n: natural :=8);
		port(
			carry_in : in std_logic ;
			carry_out : out std_logic ;	
			data_in_A : in std_logic_vector(n-1 downto 0);
			data_in_B : in std_logic_vector(n-1 downto 0);
			data_out : buffer std_logic_vector(n-1 downto 0)
		);
	end component;
	
	signal I0,I1 : std_logic_vector(n-1 downto 0); -- AND operation if MUX select is '1'
	
	begin
		
		I1 <= alu_data_in1 AND alu_data_in2 ;
		add_flag: adder_parralel port map('0', open, alu_data_in1, alu_data_in2, I0);
		mux_flag: mux_2 port map(alu_select_op, I0, I1, alu_data_out);
	
end structure;


------------------------------------------------------------------------------------------------------------------------------------------------------
--------------------------------------------------------TEST BENCHMARK OF ALU-------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;

entity test_alu is
	generic (n: natural :=8);
end test_alu;

architecture structure of test_alu is
	
	component ALU is 
		generic (n: natural :=8);
		port(
			alu_select_op :  in std_logic ;
			alu_data_in1 : in std_logic_vector(n-1 downto 0);
			alu_data_in2 : in std_logic_vector(n-1 downto 0);
			alu_data_out : buffer std_logic_vector(n-1 downto 0)
		);
	end component;
	
	signal A : std_logic_vector(n-1 downto 0) := conv_std_logic_vector(32,n);
	signal B : std_logic_vector(n-1 downto 0) := conv_std_logic_vector(16,n);
	signal op: std_logic := '0' ;
	signal result: std_logic_vector(n-1 downto 0);
	
begin
	
	comp_flag: ALU port map(op, A, B, result);
	
	sim_proc: process
	begin         
        wait for 100 ns;
        A <= conv_std_logic_vector(1,n);
		B <= conv_std_logic_vector(2,n);
		op <= '0';
		
		wait for 100 ns;
        A <= conv_std_logic_vector(22,n);
		B <= conv_std_logic_vector(12,n);
		op <= '0';
		
		wait for 100 ns;
        A <= conv_std_logic_vector(42,n);
		B <= conv_std_logic_vector(23,n);
		op <= '1';
		
		wait for 100 ns;
        A <= conv_std_logic_vector(12,n);
		B <= conv_std_logic_vector(55,n);
		op <= '0';
		
		wait for 100 ns;
        A <= conv_std_logic_vector(36,n);
		B <= conv_std_logic_vector(12,n);
		op <= '1' ;
		
        wait;
  end process;
	
end;





------------------------------------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------------------------------


library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;

entity my_ALU is 
	
	generic (n: natural :=8);
	port(
		alu_select_op :  in std_logic ;
		
		alu_data_in1 : in std_logic_vector(n-1 downto 0);
		alu_data_in2 : in std_logic_vector(n-1 downto 0);
		
		alu_data_out : buffer std_logic_vector(n-1 downto 0)
	);
	
end my_ALU;


architecture structure of my_ALU is
begin
		alu_data_out <= conv_std_logic_vector( conv_integer(alu_data_in1) + conv_integer(alu_data_in2), n) when(alu_select_op = '0') else alu_data_in1 AND alu_data_in2 ;
end structure;




