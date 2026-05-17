-- 4-bit BCD Adder
-- Lab 02 Exercise 04

entity BCD_adder is
    port(A, B : in  bit_vector(3 downto 0);
         Ci   : in  bit;
         S    : out bit_vector(3 downto 0);
         Co   : out bit);
end BCD_adder;

architecture structural of BCD_adder is

    component CR_adder
        port(A, B : in  bit_vector(3 downto 0);
             Ci   : in  bit;
             S    : out bit_vector(3 downto 0);
             Co   : out bit);
    end component;

    signal sum_bin      : bit_vector(3 downto 0);
    signal correction   : bit;
    signal correction_v : bit_vector(3 downto 0);
    signal c1, c2       : bit;

begin

    ADD1: CR_adder port map(A  => A,
                            B  => B,
                            Ci => Ci,
                            S  => sum_bin,
                            Co => c1);

    correction <= c1 or (sum_bin(3) and sum_bin(2)) or (sum_bin(3) and sum_bin(1));

    correction_v(0) <= '0';
    correction_v(1) <= correction;
    correction_v(2) <= correction;
    correction_v(3) <= '0';

    ADD2: CR_adder port map(A  => sum_bin,
                            B  => correction_v,
                            Ci => '0',
                            S  => S,
                            Co => c2);

    Co <= correction;

end structural;

