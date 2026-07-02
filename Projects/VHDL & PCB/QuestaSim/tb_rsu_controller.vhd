library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity tb_rsu_controller is
end tb_rsu_controller;

architecture sim of tb_rsu_controller is

    -- Testbench signals connected to DUT
    signal clk     : std_logic := '0';
    signal reset   : std_logic := '0';
    signal tick_1s : std_logic := '0';

    -- Request inputs, representing slide switches
    signal N_req   : std_logic := '0';
    signal S_req   : std_logic := '0';
    signal E_req   : std_logic := '0';
    signal W_req   : std_logic := '0';

    -- Grant outputs from controller
    signal N_grant : std_logic;
    signal S_grant : std_logic;
    signal E_grant : std_logic;
    signal W_grant : std_logic;

    -- Display/debug outputs
    signal road_code : std_logic_vector(1 downto 0);
    signal countdown : integer range 0 to 20;

    -- 100 MHz clock period: 10 ns
    constant CLK_PERIOD : time := 10 ns;

begin

    -- Clock generation
    clk <= not clk after CLK_PERIOD / 2;

    -- Generates a tick_1s pulse for one clock cycle.
    -- In simulation, this is faster than real 1 second to reduce simulation time.
    tick_process : process
    begin
        wait until rising_edge(clk);
        tick_1s <= '1';
        wait until rising_edge(clk);
        tick_1s <= '0';
    end process;

    -- Device Under Test: RSU controller
    DUT : entity work.rsu_controller
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

    -- Safety assertion:
    -- Main road and side road must never be granted at the same time.
    safety_check : process(clk)
    begin
        if rising_edge(clk) then
            assert not ((N_grant = '1' or S_grant = '1') and
                        (E_grant = '1' or W_grant = '1'))
            report "SAFETY ERROR: Main and side granted together"
            severity error;
        end if;
    end process;

    -- Test scenario for different traffic request conditions
    stimulus : process
    begin
        -- Apply reset
        reset <= '1';
        wait for 40 ns;
        reset <= '0';
        wait for 40 ns;

        -- SW0 = North request
        N_req <= '1';
        wait for 120 ns;

        -- SW1 = South request also active
        S_req <= '1';
        wait for 120 ns;

        -- SW2 = East request; side road starts waiting
        E_req <= '1';
        wait for 600 ns;

        -- SW3 = West request also active
        W_req <= '1';
        wait for 500 ns;

        -- Remove main road requests; side road remains active
        N_req <= '0';
        S_req <= '0';
        wait for 300 ns;

        -- Main road request comes again
        N_req <= '1';
        wait for 500 ns;

        report "Simulation finished successfully"
        severity note;

        wait;
    end process;

end sim;