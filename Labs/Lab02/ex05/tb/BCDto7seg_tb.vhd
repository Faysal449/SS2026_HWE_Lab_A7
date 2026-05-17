library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity BCDto7seg_tb is
end BCDto7seg_tb;

architecture bench of BCDto7seg_tb is

    signal bcd_tb : std_logic_vector(3 downto 0);
    signal seg_tb : std_logic_vector(6 downto 0);

    -- Expected active-low patterns, order = a b c d e f g
    type seg_array_t is array (0 to 9) of std_logic_vector(6 downto 0);
    constant expected_active_low : seg_array_t := (
        0 => "0000001", -- 0
        1 => "1001111", -- 1
        2 => "0010010", -- 2
        3 => "0000110", -- 3
        4 => "1001100", -- 4
        5 => "0100100", -- 5
        6 => "0100000", -- 6
        7 => "0001111", -- 7
        8 => "0000000", -- 8
        9 => "0000100"  -- 9
    );

begin

    UUT: entity work.BCDto7seg
        generic map (
            ACTIVE_LOW => true
        )
        port map (
            bcd => bcd_tb,
            seg => seg_tb
        );

    stim_proc: process
    begin

        -- Test all valid BCD inputs 0 to 9
        for i in 0 to 9 loop
            bcd_tb <= std_logic_vector(to_unsigned(i, 4));
            wait for 10 ns;

            assert seg_tb = expected_active_low(i)
                report "Mismatch for BCD digit " & integer'image(i)
                severity error;
        end loop;

        -- Test invalid BCD values 10 to 15.
        -- For ACTIVE_LOW=true, all segments OFF = "1111111".
        for i in 10 to 15 loop
            bcd_tb <= std_logic_vector(to_unsigned(i, 4));
            wait for 10 ns;

            assert seg_tb = "1111111"
                report "Invalid BCD input did not switch display off: " & integer'image(i)
                severity error;
        end loop;

        report "BCDto7seg testbench completed successfully.";
        wait;

    end process;

end bench;
