library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use ieee.std_logic_textio.all;
use ieee.std_logic_arith.all;
use IEEE.MATH_REAL.ALL;
use std.textio.all;

entity memory is 
	generic (address_n: integer := 4;data_n: integer := 16);
	--generic ();
	port(
		address: in std_logic_vector(address_n-1 downto 0);
		clock: in std_logic;
		data: out std_logic_vector(data_n-1 downto 0)
	);
end memory;

architecture structure of memory is
	
	type ROM is array (2**address_n-1 downto 0) of std_logic_vector (data_n-1 downto 0);
	signal mem : ROM;
	
	procedure load_ROM (signal data_word : inout ROM) is
		
		file romfile :text open read_mode is "memory_contents.mem";
		variable lbuf :line;
		variable i :integer := 0;
        variable fdata :std_logic_vector (data_n-1 downto 0);
	begin
		while not endfile(romfile) loop
            -- read data from input file
            readline(romfile, lbuf);
            read(lbuf, fdata);
            data_word(i) <= fdata;
            i := i+1;
        end loop;
	end procedure;
	
	
begin
	
	-- Procedural Call --
    load_ROM(mem);
	
	pro_flag: process(clock)
	begin
		if rising_edge(clock) then 
			data <= mem(conv_integer(unsigned(address))) ;
		end if;
	end process;
	
	
end structure;

--------------------------------------------TEST BENCHMARK ----------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use ieee.std_logic_textio.all;
use ieee.std_logic_arith.all;
use IEEE.MATH_REAL.ALL;
use std.textio.all;

entity memoty_tb is
	generic (address_n: integer := 4; data_n: integer := 16);
end memoty_tb;

architecture test of memoty_tb is



    component memory is
		generic (address_n: integer := 4; data_n: integer := 16);
		port(
			address: in std_logic_vector(address_n-1 downto 0);
			clock: in std_logic;
			data: out std_logic_vector(data_n-1 downto 0)
		);
    end component;
    
	
	
	signal address :std_logic_vector (address_n-1 downto 0) := (others=>'0');
    signal data    :std_logic_vector (data_n-1 downto 0) := (others=>'0');
    signal clock   :std_logic := '0';	
	
	
begin

    clock <= not clock after 15 ns;
    
    process begin
        for i in 0 to 2**address_n-1 loop
            address <= conv_std_logic_vector(i, address_n);
            wait for 20 ns;
        end loop;
    end process;

    Inst_Rom : memory
    port map (
        address => address, -- Address input
        clock 	=> clock,
		data    => data    -- Data output
    );

end architecture;






