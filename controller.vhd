Library work;
Library IEEE;
Use IEEE.STD_LOGIC_1164.All;
use ieee.numeric_std.all;

entity controller is
  port (
	clk: in std_logic;
	rst: in std_logic;
	start: in std_logic;
	is_operand: in std_logic;
	is_operator: in std_logic;
	is_empty: in std_logic;
	is_hash: in std_logic;
	is_lt: in std_logic;

	num0_en: out std_logic;
	num1_en: out std_logic;
	num2_en: out std_logic;
	index_cnt: out std_logic;
	sel: out std_logic;
	operand_push: out std_logic;
	operator_push: out std_logic;
	operand_pop: out std_logic;
	operator_pop: out std_logic;
	num_clr: out std_logic;
	result_en: out std_logic;
	op1_en: out std_logic;
	op2_en: out std_logic;
	operator_en: out std_logic;
	done: out std_logic;
	mode: out unsigned(1 downto 0)
  ) ;
end entity ; -- controller

architecture behavioral of controller is

	signal ps, ns: unsigned(4 downto 0);

begin
	ps_assign : process( clk )
	begin
		if rst='1' then
			ps <= (others=>'0');
		else	
			ps <= ns;		
		end if ;
	end process ; -- ps_assign

	ns_assign : process( ps, start, is_operand, is_operator, is_empty, is_hash, is_lt )
	begin
		ns <= (others=>'0');
		case( ps ) is
		
			when "00000" =>
				if start='1' then
					ns <= to_unsigned(1, 5);
				else
					ns <= to_unsigned(0, 5);
				end if ;
			when "00001" =>
				if is_operand='1' then
					ns <= to_unsigned(2, 5);
				end if ;
				if is_operator='1' then
					ns <= to_unsigned(8, 5);
				end if ;
				if is_hash='1' then
					ns <= to_unsigned(13, 5);
				end if ;
			when "00011" =>
				if is_operand='1' then
					ns <= to_unsigned(4, 5);
				end if ;
				if is_operator='1' then
					ns <= to_unsigned(8, 5);
				end if ;
				if is_hash='1' then
					ns <= to_unsigned(13, 5);
				end if ;
			when "00101" =>
				if is_operand='1' then
					ns <= to_unsigned(6, 5);
				end if ;
				if is_operator='1' then
					ns <= to_unsigned(8, 5);
				end if ;
				if is_hash='1' then
					ns <= to_unsigned(13, 5);
				end if ;
			when "00111" =>
				if is_operator='1' then
					ns <= to_unsigned(8, 5);
				end if ;
				if is_hash='1' then
					ns <= to_unsigned(13, 5);
				end if ;
			when "01000" =>
				if is_lt='1' then
					ns <= to_unsigned(9, 5);
				else
					ns <= to_unsigned(12, 5);
				end if ;
			when "01010" =>
				ns <= to_unsigned(20, 5);
			when "01011" =>
				if is_lt='1' then
					ns <= to_unsigned(21, 5);
				else
					ns <= to_unsigned(12, 5);
				end if ;
			when "01100" =>
				ns <= to_unsigned(1, 5);
			when "01111" =>
				ns <= to_unsigned(19, 5);
			when "10001" =>
				if is_empty='1' then
					ns <= to_unsigned(18, 5);
				else
					ns <= to_unsigned(14, 5);
				end if ;
			when "10010" =>
				ns <= to_unsigned(0, 5);
			when "10011" =>
				ns <= to_unsigned(16, 5);
			when "10100" =>
				ns <= to_unsigned(11, 5);
			when "10101" =>
				ns <= to_unsigned(9, 5);
			when others =>
				ns <= ps + 1;
		end case ;
	end process ; -- ns_assign

	output_assign : process( ps )
	begin
		
		case( ps ) is
			when "00001" =>
				num_clr <= '1';
			when "00010" =>
				num0_en <= '1';
				index_cnt <= '1';
			when "00100" =>
				num1_en <= '1';
				index_cnt <= '1';
			when "00101" =>
				mode <= "01";
			when "00110" =>
				num2_en <= '1';
				index_cnt <= '1';
			when "00111" =>
				mode <= "10";
			when "01000" =>
				operand_push <= '1';
			when "01001" =>
				op2_en <= '1';
				operator_en<= '1';
			when "01010" =>
				operand_pop <= '1';
				operator_pop <= '1';
				op1_en <= '1';
			when "01011" =>
				operand_pop <= '1';
				result_en <= '1';
				sel <= '1';

			when "01100" =>
				sel <= '1';
				operand_push <= '1';
				operator_push <= '1';
				index_cnt <= '1';

			when "01101" =>
				operand_push <= '1';
				sel <= '0';
			when "01110" =>
				op2_en <= '1';
				operator_en <= '1';
			when "01111" =>
				operand_pop <= '1';
				operator_pop <= '1';
				op1_en <= '1';
			when "10000" =>
				operand_pop <= '1';
				sel <= '1';
				result_en <= '1';
			when "10001" =>
				sel <= '1';
				operand_push <= '1';
			when "10010" =>
				done <= '1';
			when "10101" =>
				sel <= '1';
				operand_push <= '1';
			when others => 
				num0_en <= '0';
				num1_en <= '0';
				num2_en <= '0';
				index_cnt <= '0';
				sel <= '0';
				operand_push <= '0';
				operator_push <= '0';
				operand_pop <= '0';
				operator_pop <= '0';
				num_clr <= '0';
				result_en <= '0';
				op1_en <= '0';
				op2_en <= '0';
				operator_en <= '0';
				done <= '0';
				mode <= "00";
	end case ;
	end process ; -- output_assign
end architecture ; -- behavioral