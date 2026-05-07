
entity full_adder_bhv_tb is
end full_adder_bhv_tb;

architecture bench of full_adder_bhv_tb is

    -- Declare the design under test as a component
    component full_adder_bhv
        port(a, b, ci : in bit;
             s, co   : out bit);
    end component;

    -- Internal signals to wire to the DUT
    signal a_tb, b_tb, ci_tb : bit;
    signal s_tb, co_tb       : bit;

begin

    -- Place one full_adder_bhv and connect its pins
    uut: full_adder_bhv port map(a  => a_tb,
                                 b  => b_tb,
                                 ci => ci_tb,
                                 s  => s_tb,
                                 co => co_tb);

    -- Drive all 8 input combinations: 000, 001, 010, 011, 100, 101, 110, 111
    a_tb  <= '0', '0' after 10 ns, '0' after 20 ns, '0' after 30 ns,
             '1' after 40 ns, '1' after 50 ns, '1' after 60 ns, '1' after 70 ns;

    b_tb  <= '0', '0' after 10 ns, '1' after 20 ns, '1' after 30 ns,
             '0' after 40 ns, '0' after 50 ns, '1' after 60 ns, '1' after 70 ns;

    ci_tb <= '0', '1' after 10 ns, '0' after 20 ns, '1' after 30 ns,
             '0' after 40 ns, '1' after 50 ns, '0' after 60 ns, '1' after 70 ns;

end bench;
