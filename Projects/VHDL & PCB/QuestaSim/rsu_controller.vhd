library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity rsu_controller is
    port (
        clk       : in  std_logic;  -- FPGA clock
        reset     : in  std_logic;  -- Reset controller to IDLE
        tick_1s   : in  std_logic;  -- 1-second enable pulse

        N_req     : in  std_logic;  -- North request
        S_req     : in  std_logic;  -- South request
        E_req     : in  std_logic;  -- East request
        W_req     : in  std_logic;  -- West request

        N_grant   : out std_logic; -- North grant
        S_grant   : out std_logic; -- South grant
        E_grant   : out std_logic; -- East grant
        W_grant   : out std_logic; -- West grant

        road_code : out std_logic_vector(1 downto 0); -- 00=IDLE, 01=MAIN, 10=SIDE
        countdown : out integer range 0 to 20          -- Current timer value
    );
end rsu_controller;

architecture Behavioral of rsu_controller is

    -- FSM states
    type state_type is (IDLE, MAIN_SERVICE, MAIN_CLEAR, SIDE_SERVICE, SIDE_CLEAR);
    signal state : state_type := IDLE;

    -- Timer for service and clearance periods
    signal timer : integer range 0 to 20 := 0;

    -- Grouped road requests
    signal main_req : std_logic;
    signal side_req : std_logic;

    -- Timing constants in seconds
    constant T_MAIN  : integer := 20;
    constant T_SIDE  : integer := 10;
    constant T_CLEAR : integer := 5;

begin

    -- Main road = North/South, Side road = East/West
    main_req <= N_req or S_req;
    side_req <= E_req or W_req;

    -- Sequential FSM process: updates state and timer once per second
    process(clk, reset)
    begin
        if reset = '1' then
            state <= IDLE;
            timer <= 0;

        elsif rising_edge(clk) then
            if tick_1s = '1' then

                case state is

                    -- Wait for any road request
                    when IDLE =>
                        timer <= 0;
                        if main_req = '1' then
                            state <= MAIN_SERVICE;
                            timer <= T_MAIN;
                        elsif side_req = '1' then
                            state <= SIDE_SERVICE;
                            timer <= T_SIDE;
                        end if;

                    -- Main road active; switch only if side road is waiting
                    when MAIN_SERVICE =>
                        if side_req = '1' then
                            if timer = 0 then
                                state <= MAIN_CLEAR;
                                timer <= T_CLEAR;
                            else
                                timer <= timer - 1;
                            end if;
                        else
                            timer <= T_MAIN;
                        end if;

                    -- Clearance time after main road
                    when MAIN_CLEAR =>
                        if timer = 0 then
                            if side_req = '1' then
                                state <= SIDE_SERVICE;
                                timer <= T_SIDE;
                            elsif main_req = '1' then
                                state <= MAIN_SERVICE;
                                timer <= T_MAIN;
                            else
                                state <= IDLE;
                            end if;
                        else
                            timer <= timer - 1;
                        end if;

                    -- Side road active; switch only if main road is waiting
                    when SIDE_SERVICE =>
                        if main_req = '1' then
                            if timer = 0 then
                                state <= SIDE_CLEAR;
                                timer <= T_CLEAR;
                            else
                                timer <= timer - 1;
                            end if;
                        else
                            timer <= T_SIDE;
                        end if;

                    -- Clearance time after side road
                    when SIDE_CLEAR =>
                        if timer = 0 then
                            if main_req = '1' then
                                state <= MAIN_SERVICE;
                                timer <= T_MAIN;
                            elsif side_req = '1' then
                                state <= SIDE_SERVICE;
                                timer <= T_SIDE;
                            else
                                state <= IDLE;
                            end if;
                        else
                            timer <= timer - 1;
                        end if;

                end case;
            end if;
        end if;
    end process;

    -- Combinational output process
    process(state, N_req, S_req, E_req, W_req, timer)
    begin
        -- Default outputs
        N_grant <= '0';
        S_grant <= '0';
        E_grant <= '0';
        W_grant <= '0';
        road_code <= "00";
        countdown <= timer;

        case state is

            -- Grant only requested directions on the main road
            when MAIN_SERVICE =>
                road_code <= "01";
                if N_req = '1' then
                    N_grant <= '1';
                end if;
                if S_req = '1' then
                    S_grant <= '1';
                end if;

            -- No grants during clear time
            when MAIN_CLEAR =>
                road_code <= "01";

            -- Grant only requested directions on the side road
            when SIDE_SERVICE =>
                road_code <= "10";
                if E_req = '1' then
                    E_grant <= '1';
                end if;
                if W_req = '1' then
                    W_grant <= '1';
                end if;

            -- No grants during clear time
            when SIDE_CLEAR =>
                road_code <= "10";

            when others =>
                road_code <= "00";

        end case;
    end process;

end Behavioral;