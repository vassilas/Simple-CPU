library ieee;
use ieee.std_logic_1164.all;

package cpu_pack is 

	component ALU is 
		generic (n: natural :=8);
		port(
			alu_select_op :  in std_logic ;
			alu_data_in1 : in std_logic_vector(n-1 downto 0);
			alu_data_in2 : in std_logic_vector(n-1 downto 0);
			alu_data_out : buffer std_logic_vector(n-1 downto 0)
		);
	end component;
	
	
	component mux_2 is 
		generic (n: natural :=8);
		port(
			select_signal : in std_logic ;
			data_in0 : in std_logic_vector(n-1 downto 0);
			data_in1 : in std_logic_vector(n-1 downto 0);
			data_out : buffer std_logic_vector(n-1 downto 0)
		);
	end component;
	
	
	component data_bus is
		port(
			Memory_out: in std_logic_vector(7 downto 0);
			DataReg_out: in std_logic_vector(7 downto 0); 
			PC_out: in std_logic_vector(5 downto 0); 
			PDM : in std_logic_vector(2 downto 0);
			DataBus: out std_logic_vector(7 downto 0)
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
	
	
	component reg_parallel_load_inc is
		generic (n: integer :=8);
		port(
			clock : in std_logic ;
			reset : in std_logic ;
			load : in std_logic ;
			inc : in std_logic ;
			data_in : std_logic_vector(n-1 downto 0);
			data_out : buffer std_logic_vector(n-1 downto 0)
		);
	end component;
	
	
	component reg_parallel_load is
		generic (n: integer :=8);
		port(
			clock : in std_logic ;
			reset : in std_logic ;
			load : in std_logic ;
			data_in : std_logic_vector(n-1 downto 0);
			data_out : buffer std_logic_vector(n-1 downto 0)
		);
	end component;
	
	
	component my_micro_memory is
		generic (address_n: integer := 4;data_n: integer := 16);
		port(
			address: in std_logic_vector(address_n-1 downto 0);
			clock: in std_logic;
			data: out std_logic_vector(data_n-1 downto 0)
		);
	end component;
	
	
	component microsequencer is
		port(
			IR: 	in std_logic_vector(1 downto 0);
			clock: 	in std_logic;
			mOP: 	out std_logic_vector(10 downto 0)
		);
	end component;
	
	
	component my_main_memory is
		generic (address_n: integer := 6; data_n: integer := 8);
		port(
			address: in std_logic_vector(address_n-1 downto 0);
			clock: in std_logic;
			data: out std_logic_vector(data_n-1 downto 0)
		);
    end component;
	
	
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
	
	
end package cpu_pack;