LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.numeric_std.all;
use std.textio.all;
use ieee.std_logic_textio.all;

ENTITY ram2 IS
	PORT(
		clk : IN std_logic;
		wr  : IN std_logic;
		rd	: IN std_logic;
		reset	: IN std_logic;
		address : IN  std_logic_vector(31 DOWNTO 0);
		datain  : IN  std_logic_vector(31 DOWNTO 0);
		dataout : OUT std_logic_vector(31 DOWNTO 0));
END ENTITY ram2;

ARCHITECTURE syncram OF ram2 IS
	TYPE ram_type IS ARRAY(0 TO 4095) OF std_logic_vector(15 DOWNTO 0);
	
	impure function InitRamFromFile (RamFileName : in string) return ram_type is
		FILE RamFile : text is in RamFileName;
		variable RamFileLine : line;
		variable RAM : ram_type;
		BEGIN
			for I in ram_type'range loop
				readline (RamFile, RamFileLine);
				read (RamFileLine, RAM(I));
			end loop;
		return RAM;
	END function;

	SIGNAL ram : ram_type := InitRamFromFile("memory2.txt");
	BEGIN
		PROCESS(clk) IS
			BEGIN
				IF rising_edge(clk) THEN  
					IF wr = '1' THEN
						ram(to_integer(unsigned(address(11 downto 0)))) <= datain(31 downto 16);
						ram(to_integer(unsigned(address(11 downto 0)))+1) <= datain(15 downto 0);
					END IF;
				END IF;
		END PROCESS;
		dataout(31 downto 16) <= ram(to_integer(unsigned(address(11 downto 0)))) when (rd = '1' and reset = '0') else
					 ram(0);
		dataout(15 downto 0) <= ram(to_integer(unsigned(address(11 downto 0)))+1) when (rd = '1' and reset = '0') else
					ram(1);
END syncram;