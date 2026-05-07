
entity full_subtractor_bhv_tb is
end full_subtractor_bhv_tb;

architecture bench of full_subtractor_bhv_tb is

    -- Declare the design under test as a component
    component full_subtractor_bhv
        port(a, b, bi : in bit;
             d, bo   : out bit);
    end component;

    -- Internal signals to wire to the DUT
    signal a_tb, b_tb, bi_tb : bit;
    signal d_tb, bo_tb       : bit;

begin

    -- Place one full_subtractor_bhv and connect its pins
    uut: full_subtractor_bhv port map(a  => a_tb,
                                      b  => b_tb,
                                      bi => bi_tb,
                                      d  => d_tb,
                                      bo => bo_tb);

    -- Drive all 8 input combinations: 000, 001, 010, 011, 100, 101, 110, 111
    a_tb  <= '0', '0' after 10 ns, '0' after 20 ns, '0' after 30 ns,
             '1' after 40 ns, '1' after 50 ns, '1' after 60 ns, '1' after 70 ns;

    b_tb  <= '0', '0' after 10 ns, '1' after 20 ns, '1' after 30 ns,
             '0' after 40 ns, '0' after 50 ns, '1' after 60 ns, '1' after 70 ns;

    bi_tb <= '0', '1' after 10 ns, '0' after 20 ns, '1' after 30 ns,
             '0' after 40 ns, '1' after 50 ns, '0' after 60 ns, '1' after 70 ns;

end bench;
