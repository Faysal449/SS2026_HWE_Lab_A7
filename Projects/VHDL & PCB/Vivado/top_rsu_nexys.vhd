library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity top_rsu_nexys is
    port (
        CLK100MHZ : in  std_logic;
        BTNC      : in  std_logic;
        SW        : in  std_logic_vector(3 downto 0);
        LED       : out std_logic_vector(7 downto 0);
        SEG       : out std_logic_vector(6 downto 0);
        AN        : out std_logic_vector(7 downto 0);
        DP        : out std_logic
    );
end top_rsu_nexys;

architecture Behavioral of top_rsu_nexys is

    signal tick_1s     : std_logic := '0';
    signal sec_counter : unsigned(26 downto 0) := (others => '0');

    signal N_grant, S_grant, E_grant, W_grant : std_logic;
    signal road_code : std_logic_vector(1 downto 0);
    signal countdown : integer range 0 to 20;

    signal refresh_counter : unsigned(19 downto 0) := (others => '0');
    signal digit_select    : unsigned(2 downto 0);
    signal digit_value     : std_logic_vector(3 downto 0);

    signal tens : integer range 0 to 9;
    signal ones : integer range 0 to 9;

begin

    -- 1 Hz tick from 100 MHz clock
    process(CLK100MHZ, BTNC)
    begin
        if BTNC = '1' then
            sec_counter <= (others => '0');
            tick_1s <= '0';
        elsif rising_edge(CLK100MHZ) then
            if sec_counter = 99999999 then
                sec_counter <= (others => '0');
                tick_1s <= '1';
            else
                sec_counter <= sec_counter + 1;
                tick_1s <= '0';
            end if;
        end if;
    end process;

    U_RSU : entity work.rsu_controller
        port map (
            clk       => CLK100MHZ,
            reset     => BTNC,
            tick_1s   => tick_1s,

            N_req     => SW(0),
            S_req     => SW(1),
            E_req     => SW(2),
            W_req     => SW(3),

            N_grant   => N_grant,
            S_grant   => S_grant,
            E_grant   => E_grant,
            W_grant   => W_grant,

            road_code => road_code,
            countdown => countdown
        );

    -- LED mapping
    LED <= (others => '0');
    LED(1) <= N_grant;
    LED(3) <= S_grant;
    LED(2) <= E_grant;
    LED(4) <= W_grant;

    -- countdown digits
    tens <= countdown / 10;
    ones <= countdown mod 10;

    -- display refresh counter
    process(CLK100MHZ)
    begin
        if rising_edge(CLK100MHZ) then
            refresh_counter <= refresh_counter + 1;
        end if;
    end process;

    digit_select <= refresh_counter(19 downto 17);

    -- 8 digit display mapping
    process(digit_select, tens, ones, road_code, SW)
    begin
        AN <= "11111111";
        digit_value <= "1111";

        case digit_select is

            -- Timer display: AN7 AN6
            when "111" =>
                AN(7) <= '0';
                digit_value <= std_logic_vector(to_unsigned(tens, 4));

            when "110" =>
                AN(6) <= '0';
                digit_value <= std_logic_vector(to_unsigned(ones, 4));

            -- Intersection road display: NS or EU
            when "101" =>
                AN(5) <= '0';
                if road_code = "01" then
                    digit_value <= "1010"; -- N
                elsif road_code = "10" then
                    digit_value <= "1100"; -- E
                else
                    digit_value <= "1111"; -- blank
                end if;

            when "100" =>
                AN(4) <= '0';
                if road_code = "01" then
                    digit_value <= "1011"; -- S
                elsif road_code = "10" then
                    digit_value <= "1101"; -- U/W
                else
                    digit_value <= "1111"; -- blank
                end if;

            -- Request display: N S E U
            when "011" =>
                AN(3) <= '0';
                if SW(0) = '1' then
                    digit_value <= "1010"; -- N
                else
                    digit_value <= "1111";
                end if;

            when "010" =>
                AN(2) <= '0';
                if SW(1) = '1' then
                    digit_value <= "1011"; -- S
                else
                    digit_value <= "1111";
                end if;

            when "001" =>
                AN(1) <= '0';
                if SW(2) = '1' then
                    digit_value <= "1100"; -- E
                else
                    digit_value <= "1111";
                end if;

            when "000" =>
                AN(0) <= '0';
                if SW(3) = '1' then
                    digit_value <= "1101"; -- U/W
                else
                    digit_value <= "1111";
                end if;

            when others =>
                AN <= "11111111";
                digit_value <= "1111";

        end case;
    end process;

    -- 7 segment decoder, active-low
    process(digit_value)
    begin
        case digit_value is
            when "0000" => SEG <= "1000000"; -- 0
            when "0001" => SEG <= "1111001"; -- 1
            when "0010" => SEG <= "0100100"; -- 2
            when "0011" => SEG <= "0110000"; -- 3
            when "0100" => SEG <= "0011001"; -- 4
            when "0101" => SEG <= "0010010"; -- 5
            when "0110" => SEG <= "0000010"; -- 6
            when "0111" => SEG <= "1111000"; -- 7
            when "1000" => SEG <= "0000000"; -- 8
            when "1001" => SEG <= "0010000"; -- 9

            when "1010" => SEG <= "0101011"; -- N approx
            when "1011" => SEG <= "0010010"; -- S approx
            when "1100" => SEG <= "0000110"; -- E
            when "1101" => SEG <= "1000001"; -- U/W approx

            when others => SEG <= "1111111"; -- blank
        end case;
    end process;

    DP <= '1';

end Behavioral;