Library work;
Library IEEE;
Use IEEE.STD_LOGIC_1164.All;
use ieee.numeric_std.all;

entity tb is
end entity ; -- tb

architecture behavioral of tb is

	signal f :  integer := 0;
	signal clk: std_logic := '0';
	signal rst: std_logic := '0';
	signal start: std_logic := '0';
	signal stopSim: std_logic; 
  	constant half_period : time := 50 ns;

begin
	calc: entity work.calculator
  	port map(
	clk => clk,
	rst => rst,
	start => start
  );
  	clk <= not clk after half_period when stopSim/='1' else
    '0';

  finish: process(clk)
  begin
    if(rising_edge(clk)) then
      f <= f + 1;
    end if;
  end process;
   stim_proc: process
   begin        
      wait for 30 ns;
      rst <= '1';
      wait for 30 ns;
      rst <= '0';
    wait for 30 ns;
      start <= '1';
    wait for 90 ns;
      start <= '0';
    wait;      
   end process;
end architecture ; -- behavioral