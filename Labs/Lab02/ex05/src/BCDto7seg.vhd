library ieee;
use ieee.std_logic_1164.all;

-- Exercise 05: BCD to 7-segment converter
-- Segment order: seg(6 downto 0) = a b c d e f g
-- ACTIVE_LOW = true  -> segment ON = '0'  (common-anode style, typical FPGA boards)
-- ACTIVE_LOW = false -> segment ON = '1'  (common-cathode style)

entity BCDto7seg is
    generic (
        ACTIVE_LOW : boolean := true
    );
    port (
        bcd : in  std_logic_vector(3 downto 0);
        seg : out std_logic_vector(6 downto 0)
    );
end BCDto7seg;

architecture behavioral of BCDto7seg is
    signal seg_active_high : std_logic_vector(6 downto 0);
begin

    -- Active-high pattern, order = a b c d e f g
    -- '1' means segment ON before optional inversion.
    process(bcd)
    begin
        case bcd is
            when "0000" => seg_active_high <= "1111110"; -- 0
            when "0001" => seg_active_high <= "0110000"; -- 1
            when "0010" => seg_active_high <= "1101101"; -- 2
            when "0011" => seg_active_high <= "1111001"; -- 3
            when "0100" => seg_active_high <= "0110011"; -- 4
            when "0101" => seg_active_high <= "1011011"; -- 5
            when "0110" => seg_active_high <= "1011111"; -- 6
            when "0111" => seg_active_high <= "1110000"; -- 7
            when "1000" => seg_active_high <= "1111111"; -- 8
            when "1001" => seg_active_high <= "1111011"; -- 9
            when others => seg_active_high <= "0000000"; -- invalid BCD: display off
        end case;
    end process;

    -- Convert active-high to active-low if required
    seg <= not seg_active_high when ACTIVE_LOW else seg_active_high;

end behavioral;

