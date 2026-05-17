
-- 4-bit Ripple Carry Adder
-- Lab 02 Exercise 02

entity CR_adder is
    port(A, B : in  bit_vector(3 downto 0);
         Ci   : in  bit;
         S    : out bit_vector(3 downto 0);
         Co   : out bit);
end CR_adder;

architecture structural of CR_adder is

    component full_adder
        port(a, b, cin : in  bit;
             s, cout   : out bit);
    end component;

    signal c1, c2, c3 : bit;

begin

    FA0: full_adder port map(a => A(0), b => B(0), cin => Ci, s => S(0), cout => c1);
    FA1: full_adder port map(a => A(1), b => B(1), cin => c1, s => S(1), cout => c2);
    FA2: full_adder port map(a => A(2), b => B(2), cin => c2, s => S(2), cout => c3);
    FA3: full_adder port map(a => A(3), b => B(3), cin => c3, s => S(3), cout => Co);

end structural;
