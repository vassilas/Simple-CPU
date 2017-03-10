library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
 
entity up_down_counter is
	port( clock : in std_logic;
	reset : in std_logic;
	up_down : in std_logic;
	counter : out std_logic_vector(3 downto 0));
end up_down_counter;
 
architecture bhv of up_down_counter is
	signal t_count: std_logic_vector(3 downto 0);
	begin
	process (clock, reset)
	begin
		if (reset='1') then
			t_count <= "0000";
		elsif rising_edge(clock) then
			if up_down = '0' then
				t_count <= t_count + 1;
			else
				t_count <= t_count - 1;
			end if;
		end if;
	end process;
	 
	counter <= t_count;
end bhv;


-- SIMULATION

LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
 
-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--USE ieee.numeric_std.ALL;
 
ENTITY tb_up_down IS
END tb_up_down;
 
ARCHITECTURE behavior OF tb_up_down IS
	
	-- Component Declaration for the Unit Under Test (UUT)
	COMPONENT up_down_counter
		PORT(
		clock : IN std_logic;
		reset : IN std_logic;
		up_down : IN std_logic;
		counter : OUT std_logic_vector(3 downto 0)
		);
	END COMPONENT;
	 
	--Inputs
	signal clock : std_logic := '0';
	signal reset : std_logic := '0';
	signal up_down : std_logic := '0';
	 
	--Outputs
	signal counter : std_logic_vector(3 downto 0);
	 
	-- Clock period definitions
	constant clock_period : time := 20 ns;
	 
	BEGIN
	 
		-- Instantiate the Unit Under Test (UUT)
		uut: up_down_counter PORT MAP (
		clock => clock,
		reset => reset,
		up_down => up_down,
		counter => counter
		);
		 
		-- Clock process definitions
		clock_process :process
		begin
			clock <= '0';
			wait for clock_period/2;
			clock <= '1';
			wait for clock_period/2;
		end process;
		 
		-- Stimulus process
		stim_proc: process
		begin
			-- hold reset state for 100 ns.
			wait for 20 ns;
			reset <= '1';
			wait for 20 ns;
			reset <= '0';
			up_down <= '0';
			wait for 200 ns;
			up_down <= '1';
			wait;
		end process;
 
	END;