entity Two_Digit_Counter is
    port (
        CLK        : in bit;
        STARTSTOP  : in bit;
        CLEAR      : in bit;
        SEG        : out bit_vector(6 downto 0);
        AN         : out bit_vector(7 downto 0)
    );
end Two_Digit_Counter;

architecture behavior of Two_Digit_Counter is

    signal count_clk : bit;
    signal mux_clk   : bit;

    signal ones : integer range 0 to 9 := 0;
    signal tens : integer range 0 to 9 := 0;

    signal active_digit : bit := '0';
    signal display_num  : integer range 0 to 9 := 0;

begin

    count_divider: entity work.clk_divider
        generic map (
            N => 100000000
        )
        port map (
            CLK   => CLK,
            RESET => CLEAR,
            CLK_N => count_clk
        );

    mux_divider: entity work.clk_divider
        generic map (
            N => 100000
        )
        port map (
            CLK   => CLK,
            RESET => CLEAR,
            CLK_N => mux_clk
        );

    process (count_clk, CLEAR)
    begin
        if CLEAR = '1' then
            ones <= 0;
            tens <= 0;

        elsif count_clk'event and count_clk = '1' then
            if STARTSTOP = '1' then
                if ones = 9 then
                    ones <= 0;

                    if tens = 9 then
                        tens <= 0;
                    else
                        tens <= tens + 1;
                    end if;

                else
                    ones <= ones + 1;
                end if;
            end if;
        end if;
    end process;

    process (mux_clk, CLEAR)
    begin
        if CLEAR = '1' then
            active_digit <= '0';

        elsif mux_clk'event and mux_clk = '1' then
            active_digit <= not active_digit;
        end if;
    end process;

    process (active_digit, ones, tens)
    begin
        if active_digit = '0' then
            display_num <= ones;
            AN <= "11111110";   -- AN0: rightmost digit
        else
            display_num <= tens;
            AN <= "11111101";   -- AN1: second digit from right
        end if;
    end process;

    process (display_num)
    begin
        case display_num is
            -- SEG = CA CB CC CD CE CF CG
            -- active low: 0 = ON, 1 = OFF
            when 0 => SEG <= "0000001";
            when 1 => SEG <= "1001111";
            when 2 => SEG <= "0010010";
            when 3 => SEG <= "0000110";
            when 4 => SEG <= "1001100";
            when 5 => SEG <= "0100100";
            when 6 => SEG <= "0100000";
            when 7 => SEG <= "0001111";
            when 8 => SEG <= "0000000";
            when 9 => SEG <= "0000100";
            when others => SEG <= "1111111";
        end case;
    end process;

end behavior;