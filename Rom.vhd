Library work;
Library IEEE;
Use IEEE.STD_LOGIC_1164.All;
use ieee.numeric_std.all;

entity Rom is
  port (
	rst: in std_logic;
	index: in unsigned(4 downto 0);

	data_out: out unsigned (7 downto 0)
  );
end entity ; -- Rom

architecture behavioral of Rom is
	type mem_row is array (natural range <>) of unsigned(7 downto 0);

	signal mem : mem_row(31 downto 0);
begin
	data_out <= mem(to_integer(index));
	rom_init : process( rst )
		begin
			if rising_edge(rst) then
				mem(0) <= to_unsigned(55, 8); -- 7
				mem(1) <= to_unsigned(42, 8); -- *
				mem(2) <= to_unsigned(50, 8); -- 2
				--mem[3] <= to_unsigned(43, 8); -- +
				--mem[4] <= to_unsigned(52, 8); -- 4
				mem(3) <= to_unsigned(35, 8); -- #
			end if ;
		end process ; -- rom_init	
end architecture ; -- behavioral