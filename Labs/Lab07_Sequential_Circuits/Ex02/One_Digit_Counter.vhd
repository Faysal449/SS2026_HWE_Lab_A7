entity One_Digit_Counter is
    port (
        CLK       : in bit;
        STARTSTOP : in bit;
        CLEAR     : in bit;
        SEG       : out bit_vector(6 downto 0);
        AN        : out bit_vector(7 downto 0)
    );
end One_Digit_Counter;

architecture behavior of One_Digit_Counter is

    signal slow_clk : bit;
    signal count    : integer range 0 to 9 := 0;

begin

    divider_inst: entity work.clk_divider
        generic map (
            N => 100000000
        )
        port map (
            CLK   => CLK,
            RESET => CLEAR,
            CLK_N => slow_clk
        );

    process (slow_clk, CLEAR)
    begin
        if CLEAR = '1' then
            count <= 0;

        elsif slow_clk'event and slow_clk = '1' then
            if STARTSTOP = '1' then
                if count = 9 then
                    count <= 0;
                else
                    count <= count + 1;
                end if;
            end if;
        end if;
    end process;

    process (count)
    begin
        case count is
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

    AN <= "11111110";

end behavior;