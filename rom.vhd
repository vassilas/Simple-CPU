-------------------------------------------------------
-- Design Name : rom
-- File Name   : rom.vhd
-- Function    : ROM Using readmemb
-- Coder       : Deepak Kumar Tala (Verilog)
-- Translator  : Alexander H Pham (VHDL)
-------------------------------------------------------
library ieee;
    use ieee.std_logic_1164.all;
    use ieee.std_logic_unsigned.all;
    use ieee.std_logic_textio.all;
    use std.textio.all;

entity rom is
    port (
        ce      :in  std_logic;                     -- Chip enable
        read_en :in  std_logic;                     -- Read enable
        address :in  std_logic_vector (7 downto 0); -- Address input
        data    :out std_logic_vector (7 downto 0)  -- Data output
    );
end entity;
architecture behavior of rom is

    -- RAM block 8x256
    type RAM is array (integer range <>) of std_logic_vector (7 downto 0);
    signal mem : RAM (0 to 255);

    -- Instructions to read a text file into RAM --
    procedure Load_ROM (signal data_word :inout RAM) is
        -- Open File in Read Mode
        file romfile   :text open read_mode is "memory.list";
        variable lbuf  :line;
        variable i     :integer := 0;
        variable fdata :std_logic_vector (7 downto 0);
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
    Load_ROM(mem);

    data <= mem(conv_integer(address)) when (read_en = '1' and ce = '1') else (others=>'0');

end architecture;

-------------------------------------------------------
-- Test bench for ROM
-------------------------------------------------------
library ieee;
    use ieee.std_logic_1164.all;
    use ieee.std_logic_arith.all;
    use ieee.std_logic_unsigned.all;
    
entity rom_tb is
end entity;
architecture test of rom_tb is

    signal address :std_logic_vector (7 downto 0) := (others=>'0');
    signal read_en :std_logic := '0';
    signal ce      :std_logic := '0';
    signal data    :std_logic_vector (7 downto 0) := (others=>'0');
    signal clk     :std_logic := '0';

    component rom is
    port (
        ce      :in  std_logic;                     -- Chip enable
        read_en :in  std_logic;                     -- Read enable
        address :in  std_logic_vector (7 downto 0); -- Address input
        data    :out std_logic_vector (7 downto 0)  -- Data output
    );
    end component;
begin

    clk <= not clk after 10 ns;
    
    process begin
        for i in 0 to 255 loop
            address <= conv_std_logic_vector(i, 8);
            read_en <= '1' after 5 ns, '0' after 15 ns;
            ce      <= '1' after 5 ns, '0' after 15 ns;
            wait for 20 ns;
        end loop;
    end process;

    Inst_Rom : rom
    port map (
        address => address, -- Address input
        data    => data,    -- Data output
        read_en => read_en, -- Read enable
        ce      => ce       -- Chip enable
    );

end architecture;