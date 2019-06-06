Library work;
Library IEEE;
Use IEEE.STD_LOGIC_1164.All;
use ieee.numeric_std.all;


entity Datapath is
  port (
	rst: in std_logic;
	clk: in std_logic;
	
	sel: in std_logic;
	num_clr: in std_logic;
	
	first_en: in std_logic;
	second_en: in std_logic;
	third_en: in std_logic;

	op1_en: in std_logic;
	op2_en: in std_logic;
	operand_push: in std_logic;
	operator_push: in std_logic;

	operand_pop: in std_logic;
	operator_pop: in std_logic;
	
	mode: in unsigned(1 downto 0);
	result_en: in std_logic;

	is_operand: out std_logic;
	is_operator: out std_logic;
	is_empty: out std_logic;
	is_hash: out std_logic;
	is_lt: out std_logic;
	data_out: out unsigned(7 downto 0)
  ) ;
end entity ; -- Datapath

architecture behavioral of Datapath is

	signal operand_empty, operator_empty: std_logic;
	signal rom_index: unsigned(4 downto 0);
	signal rom_data, convereted_decimal, first, second, third, operator_data_in, operand_data_in,
		top_operator, top_operand, converted_asci, result, op1, op2, converted_operator: unsigned(7 downto 0);


begin
	converted_asci <= rom_data - to_unsigned(48, 8);
	
	convereted_decimal <= first when mode="00" else 
		second*to_unsigned(10, 8) + first when mode="01" else
		third*to_unsigned(100, 8) + second*to_unsigned(10, 8) + first;

 	converted_operator 	<=  
 						to_unsigned(0, 8) when rom_data=to_unsigned(43, 8) else 
						to_unsigned(1, 8) when rom_data=to_unsigned(45, 8) else
						to_unsigned(2, 8) when rom_data=to_unsigned(42, 8) else
						to_unsigned(3, 8);

	data_out <= top_operand;
	operand_data_in <= result when sel='1' else convereted_decimal;

	is_operand <= '1' when (rom_data > to_unsigned(47, 8) and rom_data < to_unsigned(58, 8)) else '0';
	is_operator <= '1' when (rom_data > to_unsigned(41, 8) and rom_data < to_unsigned(48, 8)) else '0';
	is_hash <= '1' when rom_data=to_unsigned(35, 8) else '0';
	is_lt <= '1' when ((converted_operator="01" and top_operator="00") or
					(converted_operator="11" and top_operator="10") or
					(converted_operator < top_operator)) else '0';

	ROM :entity work.Rom
	port map(
		rst => rst,
		index => rom_index,
		data_out => rom_data
		);

	operand_stack: entity work.Stack
	port map(
		clk => clk,
		push => operand_push,
		pop => operand_pop,

		data_in => operand_data_in,

		is_empty => operand_empty,
		data_out => top_operand
	);
	operator_stack: entity work.Stack
	port map(
		clk => clk,
		push => operator_push,
		pop => operator_pop,

		data_in => operator_data_in,

		is_empty => operator_empty,
		data_out => top_operator
	);

	digits : process( first_en, second_en, third_en, rst, num_clr )
	begin
		if rst='1' or num_clr='1' then
			first <= (others=>'0');
			second <= (others=>'0');
			third <= (others=>'0');
		end if ;
		if first_en='1' then
			first <= converted_asci;
		end if ;
		if second_en='1' then
			second <= converted_asci;
		end if ;
		if third_en='1' then
			third <= converted_asci;
		end if ;
	end process ; -- digits

	op_assign : process( clk )
	begin
		if rising_edge(clk) then
			if rst='1' then
				op1 <= (others=>'0');
				op2 <= (others=>'0');
			else
				if op1_en='1' then
					op1 <= top_operand;
				end if ;
				if op2_en='1' then
					op2 <= top_operand;
				end if ;
			end if ;

		end if ;
	end process ; -- op_assign
	cnt : process( clk )
	begin
		if rising_edge(clk) then
			if rst='1' then
				rom_index <= (others=>'0');
			else
				rom_index <= rom_index + 1;
			end if ;

		end if ;
	end process ; -- cnt

	result_assign : process( rst )
	begin
		if rst='1' then
			result <= (others=>'0');
		else
			if result_en='1' then
				if top_operator = to_unsigned(0, 8) then
					result 	<= 	op1 + op2;
				end if ;
				if  top_operator = to_unsigned(1, 8) then
					result <= op1 - op2;
				end if ;
				if top_operator = to_unsigned(2, 8) then
					result <= op1 * op2;
				end if ;
			end if ;
		end if ;
	end process ; -- result_assign

end architecture ; -- behavioral