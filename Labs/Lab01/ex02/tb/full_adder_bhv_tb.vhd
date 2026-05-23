entity full_adder_tb is
end entity;

architecture bhv of full_adder is

signal 
a_tb, b_tb, ci_tb, s_tb, co_tb: bit;

component full_adder is

port 
( a: in bit;
b: in bit;
ci: in bit;
s: out bit;
co: out bit
);

end component;

begin

UUT: full_adder
port map (
a => a_tb,
b => b_tb,
ci => ci_tb,
s => s_tb,
co => co_tb
);

stimulus: process
begin 

a_tb <= '0';
b_tb <= '0';
ci_tb <= '0';
wait for 10 ns;

a_tb <= '0';
b_tb <= '0';
ci_tb <= '1';
wait for 10 ns;

a_tb <= '0';
b_tb <= '1';
ci_tb <= '0';
wait for 10 ns;

a_tb <= '0';
b_tb <= '1';
ci_tb <= '1';
wait for 10 ns;

a_tb <= '1';
b_tb <= '0';
ci_tb <= '0';
wait for 10 ns;

a_tb <= '1';
b_tb <= '0';
ci_tb <= '1';
wait for 10 ns;

a_tb <= '1';
b_tb <= '1';
ci_tb <= '0';
wait for 10 ns;

a_tb <= '1';
b_tb <= '1';
ci_tb <= '1';
wait for 10 ns;

wait;

end process;

end bhv;
