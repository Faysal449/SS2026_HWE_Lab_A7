-- RSU intersection controller for QuestaSim waveform
-- Author: generated for Azad
-- Main road  : North + South
-- Side road  : East + West
-- Priority   : main road first, side road served after the main service timer

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity rsu_controller is
    port (
        clk     : in  std_logic;
        reset   : in  std_logic;
        tick_1s : in  std_logic;

        N_req   : in  std_logic;
        S_req   : in  std_logic;
        E_req   : in  std_logic;
        W_req   : in  std_logic;

        N_grant : out std_logic;
        S_grant : out std_logic;
        E_grant : out std_logic;
        W_grant : out std_logic;

        main_req_wave   : out std_logic;
        side_req_wave   : out std_logic;
        main_grant_wave : out std_logic;
        side_grant_wave : out std_logic;
        conflict_wave   : out std_logic;

        road_code : out std_logic_vector(1 downto 0);  -- 00 idle, 01 main, 10 side
        countdown : out unsigned(4 downto 0)
    );
end entity rsu_controller;

architecture rtl of rsu_controller is

    type state_t is (IDLE, MAIN_SERVICE, SIDE_SERVICE);

    -- These two internal signals are intentionally named "state" and "timer"
    -- so that they appear in Questa as /tb_rsu_controller/dut/state and /timer.
    signal state : state_t := IDLE;
    signal timer : unsigned(4 downto 0) := (others => '0');

    signal main_req : std_logic;
    signal side_req : std_logic;

    constant MAIN_TIME : unsigned(4 downto 0) := to_unsigned(20, 5);
    constant SIDE_TIME : unsigned(4 downto 0) := to_unsigned(10, 5);

begin

    main_req <= N_req or S_req;
    side_req <= E_req or W_req;

    process (clk)
    begin
        if rising_edge(clk) then
            if reset = '1' then
                state <= IDLE;
                timer <= (others => '0');

            elsif tick_1s = '1' then
                case state is
                    when IDLE =>
                        if main_req = '1' then
                            state <= MAIN_SERVICE;
                            timer <= MAIN_TIME;
                        elsif side_req = '1' then
                            state <= SIDE_SERVICE;
                            timer <= SIDE_TIME;
                        else
                            state <= IDLE;
                            timer <= (others => '0');
                        end if;

                    when MAIN_SERVICE =>
                        if main_req = '0' and side_req = '0' then
                            state <= IDLE;
                            timer <= (others => '0');
                        elsif main_req = '0' and side_req = '1' then
                            state <= SIDE_SERVICE;
                            timer <= SIDE_TIME;
                        elsif timer <= to_unsigned(1, 5) then
                            if side_req = '1' then
                                state <= SIDE_SERVICE;
                                timer <= SIDE_TIME;
                            else
                                state <= MAIN_SERVICE;
                                timer <= MAIN_TIME;
                            end if;
                        else
                            timer <= timer - 1;
                        end if;

                    when SIDE_SERVICE =>
                        if main_req = '0' and side_req = '0' then
                            state <= IDLE;
                            timer <= (others => '0');
                        elsif side_req = '0' and main_req = '1' then
                            state <= MAIN_SERVICE;
                            timer <= MAIN_TIME;
                        elsif timer <= to_unsigned(1, 5) then
                            if main_req = '1' then
                                state <= MAIN_SERVICE;
                                timer <= MAIN_TIME;
                            else
                                state <= SIDE_SERVICE;
                                timer <= SIDE_TIME;
                            end if;
                        else
                            timer <= timer - 1;
                        end if;
                end case;
            end if;
        end if;
    end process;

    -- Grants: only the active road receives permission.
    N_grant <= '1' when (state = MAIN_SERVICE and N_req = '1') else '0';
    S_grant <= '1' when (state = MAIN_SERVICE and S_req = '1') else '0';
    E_grant <= '1' when (state = SIDE_SERVICE and E_req = '1') else '0';
    W_grant <= '1' when (state = SIDE_SERVICE and W_req = '1') else '0';

    main_req_wave <= main_req;
    side_req_wave <= side_req;
    main_grant_wave <= '1' when state = MAIN_SERVICE else '0';
    side_grant_wave <= '1' when state = SIDE_SERVICE else '0';
    conflict_wave <= main_req and side_req;

    road_code <= "01" when state = MAIN_SERVICE else
                 "10" when state = SIDE_SERVICE else
                 "00";

    countdown <= timer;

end architecture rtl;
