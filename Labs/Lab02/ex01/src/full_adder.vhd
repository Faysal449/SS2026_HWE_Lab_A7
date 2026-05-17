-- 1-bit Full Adder (structural)
-- Built from two half adders and an OR gate
-- Lab 02 Exercise 01

entity full_adder is
    port(a, b, cin : in  bit;
         s, cout   : out bit);
end full_adder;

architecture structural of full_adder is

    component half_adder
        port(a, b  : in  bit;
             s, co : out bit);
    end component;

    signal s1, c1, c2 : bit;

begin

    HA1: half_adder port map(a => a,  b => b,   s => s1, co => c1);
    HA2: half_adder port map(a => s1, b => cin, s => s,  co => c2);

    cout <= c1 or c2;

end structural;
