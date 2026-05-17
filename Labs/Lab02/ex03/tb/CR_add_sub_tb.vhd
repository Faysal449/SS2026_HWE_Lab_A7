

-- Testbench for 4-bit Adder/Subtractor
-- Lab 02 Exercise 03

entity CR_add_sub_tb is
end CR_add_sub_tb;

architecture bench of CR_add_sub_tb is

    component CR_add_sub
        port(A, B : in  bit_vector(3 downto 0);
             M    : in  bit;
             S    : out bit_vector(3 downto 0);
             Co   : out bit);
    end component;

    signal A_tb, B_tb, S_tb : bit_vector(3 downto 0);
    signal M_tb, Co_tb      : bit;

begin

    uut: CR_add_sub port map(A  => A_tb,
                             B  => B_tb,
                             M  => M_tb,
                             S  => S_tb,
                             Co => Co_tb);

    A_tb <= "0000",
            "0011" after 10 ns,
            "1111" after 20 ns,
            "0111" after 30 ns,
            "0101" after 40 ns,
            "0011" after 50 ns,
            "1111" after 60 ns,
            "0000" after 70 ns;

    B_tb <= "0000",
            "0101" after 10 ns,
            "0001" after 20 ns,
            "1000" after 30 ns,
            "0011" after 40 ns,
            "0101" after 50 ns,
            "1111" after 60 ns,
            "0001" after 70 ns;

    M_tb <= '0',
            '0' after 10 ns,
            '0' after 20 ns,
            '0' after 30 ns,
            '1' after 40 ns,
            '1' after 50 ns,
            '1' after 60 ns,
            '1' after 70 ns;

end bench;
