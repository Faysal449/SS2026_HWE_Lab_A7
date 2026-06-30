-- Testbench for the RSU controller.
-- It creates the same signal names and scenario order visible in the screenshot:
-- 0 -> 1 -> 0 -> 2 -> 0 -> 3 -> 0 -> 4

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity tb_rsu_controller is
end entity tb_rsu_controller;

architecture sim of tb_rsu_controller is

    signal scenario_id : std_logic_vector(2 downto 0) := "000";

    signal clk     : std_logic := '0';
    signal reset   : std_logic := '1';
    signal tick_1s : std_logic := '0';

    signal N_req : std_logic := '0';
    signal S_req : std_logic := '0';
    signal E_req : std_logic := '0';
    signal W_req : std_logic := '0';

    signal N_grant : std_logic;
    signal S_grant : std_logic;
    signal E_grant : std_logic;
    signal W_grant : std_logic;

    signal main_req_wave   : std_logic;
    signal side_req_wave   : std_logic;
    signal main_grant_wave : std_logic;
    signal side_grant_wave : std_logic;
    signal conflict_wave   : std_logic;

    signal road_code : std_logic_vector(1 downto 0);
    signal countdown : unsigned(4 downto 0);

begin

    dut : entity work.rsu_controller
        port map (
            clk     => clk,
            reset   => reset,
            tick_1s => tick_1s,

            N_req   => N_req,
            S_req   => S_req,
            E_req   => E_req,
            W_req   => W_req,

            N_grant => N_grant,
            S_grant => S_grant,
            E_grant => E_grant,
            W_grant => W_grant,

            main_req_wave   => main_req_wave,
            side_req_wave   => side_req_wave,
            main_grant_wave => main_grant_wave,
            side_grant_wave => side_grant_wave,
            conflict_wave   => conflict_wave,

            road_code => road_code,
            countdown => countdown
        );

    -- Fast simulation clock.
    clk <= not clk after 4 ns;

    -- Artificial 1-second tick for waveform demonstration.
    tick_proc : process
    begin
        tick_1s <= '0';
        wait for 16 ns;
        while true loop
            tick_1s <= '1';
            wait for 8 ns;
            tick_1s <= '0';
            wait for 24 ns;
        end loop;
    end process tick_proc;

    stim_proc : process
    begin
        -- SCENARIO 0: reset/idle
        scenario_id <= "000";
        N_req <= '0'; S_req <= '0'; E_req <= '0'; W_req <= '0';
        reset <= '1';
        wait for 48 ns;
        reset <= '0';
        wait for 32 ns;

        -- SCENARIO 1: main road request only, North and South are served.
        scenario_id <= "001";
        N_req <= '1'; S_req <= '1'; E_req <= '0'; W_req <= '0';
        wait for 160 ns;

        -- Back to idle.
        scenario_id <= "000";
        N_req <= '0'; S_req <= '0'; E_req <= '0'; W_req <= '0';
        reset <= '1';
        wait for 32 ns;
        reset <= '0';
        wait for 96 ns;

        -- SCENARIO 2: side road request only, East and West are served.
        scenario_id <= "010";
        N_req <= '0'; S_req <= '0'; E_req <= '1'; W_req <= '1';
        wait for 192 ns;

        -- Back to idle.
        scenario_id <= "000";
        N_req <= '0'; S_req <= '0'; E_req <= '0'; W_req <= '0';
        reset <= '1';
        wait for 32 ns;
        reset <= '0';
        wait for 128 ns;

        -- SCENARIO 3: both main and side requests are active.
        -- Main road is served first, then side road gets service after timer expiry.
        scenario_id <= "011";
        N_req <= '1'; S_req <= '1'; E_req <= '1'; W_req <= '1';
        wait for 760 ns;

        -- Back to idle.
        scenario_id <= "000";
        N_req <= '0'; S_req <= '0'; E_req <= '0'; W_req <= '0';
        reset <= '1';
        wait for 32 ns;
        reset <= '0';
        wait for 96 ns;

        -- SCENARIO 4: long mixed traffic scenario.
        scenario_id <= "100";
        N_req <= '1'; S_req <= '1'; E_req <= '0'; W_req <= '0';
        wait for 160 ns;
        E_req <= '1'; W_req <= '1';       -- side road starts waiting while main is active
        wait for 520 ns;
        N_req <= '0'; S_req <= '0';       -- only side road remains
        wait for 240 ns;
        E_req <= '0'; W_req <= '0';
        wait for 160 ns;

        wait;
    end process stim_proc;

end architecture sim;
