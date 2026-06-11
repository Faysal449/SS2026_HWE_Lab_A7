entity clk_divider is
    generic (
        N : integer := 10
    );
    port (
        CLK   : in bit;
        RESET : in bit;
        CLK_N : out bit
    );
end clk_divider;

architecture behavior of clk_divider is
    signal count : integer range 0 to (N/2)-1 := 0;
    signal temp_clk : bit := '0';
begin

    process (CLK, RESET)
    begin
        if RESET = '1' then
            count <= 0;
            temp_clk <= '0';

        elsif CLK'event and CLK = '1' then
            if count = (N/2)-1 then
                count <= 0;
                temp_clk <= not temp_clk;
            else
                count <= count + 1;
            end if;
        end if;
    end process;

    CLK_N <= temp_clk;

end behavior;