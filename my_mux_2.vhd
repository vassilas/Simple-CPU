library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;

entity my_mux_2 is 
	generic (n: natural :=8);
	port(
		select_signal : in std_logic ;
		data_in0 : in std_logic_vector(n-1 downto 0);
		data_in1 : in std_logic_vector(n-1 downto 0);
		data_out : buffer std_logic_vector(n-1 downto 0)
	);
end my_mux_2;

architecture structure of my_mux_2 is
begin
	process(select_signal)
	begin
		case select_signal is
			when '0' => data_out <= data_in0;
			when '1' => data_out <= data_in1;
			when others => data_out <= data_in0;
		end case ;
	end process ;
end structure;