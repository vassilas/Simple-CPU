library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use ieee.std_logic_textio.all;
use ieee.std_logic_arith.all;
use IEEE.MATH_REAL.ALL;
use std.textio.all;

entity micro_LUT is 
	generic (address_n: integer := 4;data_n: integer := 16);
	port(
		address: in std_logic_vector(address_n-1 downto 0);
		data: out std_logic_vector(data_n-1 downto 0)
	);
end micro_LUT;

architecture structure of micro_LUT is
	
	type ROM is array (2**address_n-1 downto 0) of std_logic_vector (data_n-1 downto 0);
	signal mem : ROM;
	
	procedure load_ROM (signal data_word : inout ROM) is
		
		file romfile :text open read_mode is "micromemory_data.mem";
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
	
	data <= mem(conv_integer(unsigned(address))) ;

end structure;