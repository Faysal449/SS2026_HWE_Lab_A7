entity half_subtractor is
    port(a, b  : in bit;
         d, bo : out bit);
end half_subtractor;

architecture behavioral of half_subtractor is
begin
    d  <= a xor b;
    bo <= (not a) and b;
end behavioral;
