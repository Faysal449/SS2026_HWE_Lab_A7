library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
use STD.ENV.ALL;

entity tb_rsu_controller is
end tb_rsu_controller;

architecture sim of tb_rsu_controller is

    constant CLK_PERIOD : time := 10 ns;

    signal clk       : std_logic := '0';
    signal reset     : std_logic := '0';
    signal tick_1s   : std_logic := '0';

    signal N_req     : std_logic := '0';
    signal S_req     : std_logic := '0';
    signal E_req     : std_logic := '0';
    signal W_req     : std_logic := '0';

    signal N_grant   : std_logic;
    signal S_grant   : std_logic;
    signal E_grant   : std_logic;
    signal W_grant   : std_logic;

    signal road_code : std_logic_vector(1 downto 0);
    signal countdown : integer range 0 to 20;

    -- Extra waveform helper signals
    signal main_req_wave    : std_logic;
    signal side_req_wave    : std_logic;
    signal main_grant_wave  : std_logic;
    signal side_grant_wave  : std_logic;
    signal conflict_wave    : std_logic;

    -- 1 = Q1, 2 = Q2, 3 = Q3, 4 = Q4
    signal scenario_id : integer range 0 to 4 := 0;

    signal sim_done : boolean := false;

begin

    --------------------------------------------------------------------
    -- DUT: your RSU controller
    --------------------------------------------------------------------
    dut : entity work.rsu_controller
        port map (
            clk       => clk,
            reset     => reset,
            tick_1s   => tick_1s,

            N_req     => N_req,
            S_req     => S_req,
            E_req     => E_req,
            W_req     => W_req,

            N_grant   => N_grant,
            S_grant   => S_grant,
            E_grant   => E_grant,
            W_grant   => W_grant,

            road_code => road_code,
            countdown => countdown
        );

    --------------------------------------------------------------------
    -- Helper signals for easier waveform explanation
    --------------------------------------------------------------------
    main_req_wave   <= N_req or S_req;
    side_req_wave   <= E_req or W_req;

    main_grant_wave <= N_grant or S_grant;
    side_grant_wave <= E_grant or W_grant;

    conflict_wave   <= main_grant_wave and side_grant_wave;

    --------------------------------------------------------------------
    -- Clock generation
    --------------------------------------------------------------------
    clk_process : process
    begin
        while not sim_done loop
            clk <= '0';
            wait for CLK_PERIOD / 2;
            clk <= '1';
            wait for CLK_PERIOD / 2;
        end loop;
        wait;
    end process;

    --------------------------------------------------------------------
    -- Safety assertion: main and side must never be granted together
    --------------------------------------------------------------------
    safety_check : process(clk)
    begin
        if rising_edge(clk) then
            assert conflict_wave = '0'
                report "ERROR: Main road and side road granted at the same time!"
                severity error;
        end if;
    end process;

    --------------------------------------------------------------------
    -- Stimulus process
    --------------------------------------------------------------------
    stim_proc : process

        procedure one_tick is
        begin
            tick_1s <= '1';
            wait until rising_edge(clk);
            wait for 1 ns;
            tick_1s <= '0';
            wait until rising_edge(clk);
            wait for 1 ns;
        end procedure;

        procedure many_ticks(n : natural) is
        begin
            for i in 1 to n loop
                one_tick;
            end loop;
        end procedure;

        procedure reset_dut is
        begin
            scenario_id <= 0;

            N_req <= '0';
            S_req <= '0';
            E_req <= '0';
            W_req <= '0';
            tick_1s <= '0';

            reset <= '1';
            wait for 25 ns;
            wait until rising_edge(clk);
            wait for 1 ns;
            reset <= '0';

            many_ticks(2);
        end procedure;

    begin

        ----------------------------------------------------------------
        -- Q1: Main-road request waveform
        -- N/S request active and N/S grant active
        ----------------------------------------------------------------
        reset_dut;

        scenario_id <= 1;
        report "Q1: Main-road request waveform";

        N_req <= '1';
        S_req <= '1';
        E_req <= '0';
        W_req <= '0';

        many_ticks(8);

        N_req <= '0';
        S_req <= '0';

        many_ticks(2);
        wait for 80 ns;


        ----------------------------------------------------------------
        -- Q2: Side-road request waveform
        -- E/W request active and E/W grant active
        ----------------------------------------------------------------
        reset_dut;

        scenario_id <= 2;
        report "Q2: Side-road request waveform";

        N_req <= '0';
        S_req <= '0';
        E_req <= '1';
        W_req <= '1';

        many_ticks(8);

        E_req <= '0';
        W_req <= '0';

        many_ticks(2);
        wait for 80 ns;


        ----------------------------------------------------------------
        -- Q3: Conflict-free waveform
        -- Main and side requests active together,
        -- but main grant and side grant are never active together
        ----------------------------------------------------------------
        reset_dut;

        scenario_id <= 3;
        report "Q3: Conflict-free waveform";

        N_req <= '1';
        S_req <= '1';
        E_req <= '1';
        W_req <= '1';

        many_ticks(35);

        N_req <= '0';
        S_req <= '0';
        E_req <= '0';
        W_req <= '0';

        many_ticks(2);
        wait for 80 ns;


        ----------------------------------------------------------------
        -- Q4: Fairness waveform
        -- Side road waits, then receives grant after timing condition
        ----------------------------------------------------------------
        reset_dut;

        scenario_id <= 4;
        report "Q4: Fairness waveform";

        -- Main road comes first
        N_req <= '1';
        S_req <= '1';
        E_req <= '0';
        W_req <= '0';

        many_ticks(5);

        -- Side road now starts waiting
        E_req <= '1';
        W_req <= '1';

        -- Keep all requests active long enough
        -- Side will get grant after main countdown and clear time
        many_ticks(35);

        N_req <= '0';
        S_req <= '0';
        E_req <= '0';
        W_req <= '0';

        many_ticks(2);

        report "Simulation finished successfully";

        sim_done <= true;
        stop;

    end process;

end sim;
