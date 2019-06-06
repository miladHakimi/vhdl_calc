entity Stack is
  port (
	clk: in std_logic;
	push: in std_logic;
	pop: in std_logic;

	data_in: in unsigned(7 downto 0);

	is_empty: out std_logic;
	data_out: out unsigned(7 downto 0)
  ) ;
end entity ; -- Stack

architecture behavioral of Stack is

	type mem_row is array (natural range <>) of unsigned(7 downto 0);

	signal mem : mem_row(31 downto 0);
	signal sp: unsigned(4 downto 0) :=( others=>'0');

begin
	push_pop : process( clk )
	begin
		if rising_edge(clk) then
			if push='1' then
				mem_row[sp] <= data_in;
				sp <= sp + 1;
			end if ;
			if pop='1' and sp>(others=>'0') then
				sp <= sp - to_unsigned(1, 5);
			end if ;
		end if ;
	end process ; -- push_pop

	is_empty <= '1' when sp=(others=>'0') else '0';
	data_out <= mem_row[sp];

end architecture ; -- behavioral