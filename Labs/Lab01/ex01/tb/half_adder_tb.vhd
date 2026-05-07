entity half_adder_tb is
end half_adder_tb;

architecture bench of half_adder_tb is

    component half_adder
        port(a, b   : in bit;
             s, co  : out bit);
    end component;

    signal a_tb, b_tb   : bit;
    signal s_tb, co_tb  : bit;

begin

    uut: half_adder port map(a  => a_tb,
                             b  => b_tb,
                             s  => s_tb,
                             co => co_tb);

    a_tb <= '0', '0' after 10 ns, '1' after 20 ns, '1' after 30 ns;
    b_tb <= '0', '1' after 10 ns, '0' after 20 ns, '1' after 30 ns;

end bench;

