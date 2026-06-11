entity clk_divider_tb is
end clk_divider_tb;

architecture behavior of clk_divider_tb is

    signal CLK   : bit := '0';
    signal RESET : bit := '0';
    signal CLK_N : bit;

begin

    uut: entity work.clk_divider
        generic map (
            N => 4
        )
        port map (
            CLK   => CLK,
            RESET => RESET,
            CLK_N => CLK_N
        );

    clk_process: process
    begin
        while true loop
            CLK <= '0';
            wait for 5 ns;
            CLK <= '1';
            wait for 5 ns;
        end loop;
    end process;

    stim_process: process
    begin
        RESET <= '1';
        wait for 20 ns;

        RESET <= '0';
        wait for 200 ns;

        wait;
    end process;

end behavior;