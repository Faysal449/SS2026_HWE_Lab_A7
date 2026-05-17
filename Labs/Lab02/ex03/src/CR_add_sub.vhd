
-- 1-bit Half Adder (behavioral)
-- Lab 01 Exercise 02

entity half_adder is
    port(a, b   : in  bit;
         s, co  : out bit);
end half_adder;

architecture behavioral of half_adder is
begin
    s  <= a xor b;
    co <= a and b;
end behavioral;
