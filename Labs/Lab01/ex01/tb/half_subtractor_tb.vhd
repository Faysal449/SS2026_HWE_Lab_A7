entity half_subtractor_tb is
end half_subtractor_tb;

architecture bench of half_subtractor_tb is

    -- Declare the design under test as a component
    component half_subtractor
        port(a, b  : in bit;
             d, bo : out bit);
    end component;

    -- Internal signals to wire to the DUT
    signal a_tb, b_tb   : bit;
    signal d_tb, bo_tb  : bit;

begin

    -- Place one half_subtractor and connect its pins
    uut: half_subtractor port map(a  => a_tb,
                                  b  => b_tb,
                                  d  => d_tb,
                                  bo => bo_tb);

    -- Drive all 4 input combinations: 00, 01, 10, 11
    a_tb <= '0', '0' after 10 ns, '1' after 20 ns, '1' after 30 ns;
    b_tb <= '0', '1' after 10 ns, '0' after 20 ns, '1' after 30 ns;

end bench;
