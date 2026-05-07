entity full_subtractor_bhv is
    port(a, b, bi : in bit;
         d, bo   : out bit);
end full_subtractor_bhv;

architecture behavioral of full_subtractor_bhv is
begin
    d  <= a xor b xor bi;
    bo <= ((not a) and b) or ((not a) and bi) or (b and bi);
end behavioral;
