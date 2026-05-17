

-- Testbench for 1-bit Full Adder
-- Drives all 8 input combinations for 100% coverage
-- Lab 02 Exercise 01

entity full_adder_tb is
end full_adder_tb;

architecture bench of full_adder_tb is

    component full_adder
        port(a, b, cin : in  bit;
             s, cout   : out bit);
    end component;

    signal a_tb, b_tb, cin_tb : bit;
    signal s_tb, cout_tb      : bit;

begin

    uut: full_adder port map(a    => a_tb,
                             b    => b_tb,
                             cin  => cin_tb,
                             s    => s_tb,
                             cout => cout_tb);

    a_tb   <= '0', '0' after 10 ns, '0' after 20 ns, '0' after 30 ns,
              '1' after 40 ns, '1' after 50 ns, '1' after 60 ns, '1' after 70 ns;

    b_tb   <= '0', '0' after 10 ns, '1' after 20 ns, '1' after 30 ns,
              '0' after 40 ns, '0' after 50 ns, '1' after 60 ns, '1' after 70 ns;

    cin_tb <= '0', '1' after 10 ns, '0' after 20 ns, '1' after 30 ns,
              '0' after 40 ns, '1' after 50 ns, '0' after 60 ns, '1' after 70 ns;

end bench;
