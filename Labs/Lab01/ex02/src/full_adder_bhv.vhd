entity full_adder_bhv is
    port(a, b, ci : in bit;
         s, co   : out bit);
end full_adder_bhv;

architecture behavioral of full_adder_bhv is
begin
    s  <= a xor b xor ci;
    co <= (a and b) or (b and ci) or (a and ci);
end behavioral;
