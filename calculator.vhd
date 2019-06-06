Library work;
Library IEEE;
Use IEEE.STD_LOGIC_1164.All;
use ieee.numeric_std.all;

entity calculator is
  port (
	clk: std_logic;
	rst: std_logic;
	start: std_logic
  ) ;
end entity ; -- calculator

architecture behavioal of calculator is

	signal is_operand, is_operator, is_empty, is_hash, is_lt, num0_en, num1_en, num2_en, index_cnt, sel,
			operand_push, operator_push, operand_pop, operator_pop, num_clr, result_en, op1_en, op2_en, operator_en, done
			:std_logic;
	signal mode: unsigned(1 downto 0);
	signal data_out: unsigned(7 downto 0);

begin
cu: entity work.controller
  port map(
	clk => clk,
	rst => rst,
	start => start,
	is_operand => is_operand,
	is_operator => is_operator,
	is_empty => is_empty,
	is_hash => is_hash,
	is_lt => is_lt,

	num0_en => num0_en,
	num1_en => num1_en,
	num2_en => num2_en,
	index_cnt => index_cnt,
	sel => sel,
	operand_push => operand_push,
	operator_push => operator_push,
	operand_pop => operand_pop,
	operator_pop => operator_pop,
	num_clr => num_clr,
	result_en => result_en,
	op1_en => op1_en,
	op2_en => op2_en,
	operator_en => operator_en,
	done => done,
	mode => mode
  ) ;
  dp: entity work.Datapath
  port map (
	rst => rst,
	clk => clk,
	
	sel => sel,
	num_clr => num_clr,
	
	first_en => num0_en,
	second_en => num1_en,
	third_en => num2_en,

	op1_en => op1_en,
	op2_en => op2_en,
	operand_push => operand_push,
	operator_push => operator_push,

	operand_pop => operand_pop,
	operator_pop => operator_pop,
	
	mode => mode,
	result_en => result_en,

	is_operand => is_operand,
	is_operator => is_operator,
	is_empty => is_empty,
	is_hash => is_hash,
	is_lt => is_lt,
	
	data_out => data_out
  );
end architecture ; -- behavioal