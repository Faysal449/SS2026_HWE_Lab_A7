-- Testbench for 4-bit Ripple Carry Adder
-- Lab 02 Exercise 02

entity CR_adder_tb is
end CR_adder_tb;

architecture bench of CR_adder_tb is

    component CR_adder
        port(A, B : in  bit_vector(3 downto 0);
             Ci   : in  bit;
             S    : out bit_vector(3 downto 0);
             Co   : out bit);
    end component;

    signal A_tb, B_tb, S_tb : bit_vector(3 downto 0);
    signal Ci_tb, Co_tb     : bit;

begin

    uut: CR_adder port map(A  => A_tb,
                           B  => B_tb,
                           Ci => Ci_tb,
                           S  => S_tb,
                           Co => Co_tb);

    A_tb  <= "0000",
             "0001" after 10 ns,
             "0101" after 20 ns,
             "1111" after 30 ns,
             "1111" after 40 ns,
             "1111" after 50 ns,
             "1010" after 60 ns,
             "0111" after 70 ns;

    B_tb  <= "0000",
             "0010" after 10 ns,
             "0011" after 20 ns,
             "0000" after 30 ns,
             "1111" after 40 ns,
             "1111" after 50 ns,
             "0101" after 60 ns,
             "0001" after 70 ns;

    Ci_tb <= '0',
             '0' after 10 ns,
             '0' after 20 ns,
             '1' after 30 ns,
             '0' after 40 ns,
             '1' after 50 ns,
             '0' after 60 ns,
             '1' after 70 ns;

end bench;
