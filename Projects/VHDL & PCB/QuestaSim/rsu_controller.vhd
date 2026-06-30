library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity rsu_controller is
    port (
        clk       : in  std_logic;
        reset     : in  std_logic;
        tick_1s   : in  std_logic;

        N_req     : in  std_logic;
        S_req     : in  std_logic;
        E_req     : in  std_logic;
        W_req     : in  std_logic;

        N_grant   : out std_logic;
        S_grant   : out std_logic;
        E_grant   : out std_logic;
        W_grant   : out std_logic;

        road_code : out std_logic_vector(1 downto 0);
        countdown : out integer range 0 to 20
    );
end rsu_controller;

architecture Behavioral of rsu_controller is

    type state_type is (IDLE, MAIN_SERVICE, MAIN_CLEAR, SIDE_SERVICE, SIDE_CLEAR);
    signal state : state_type := IDLE;
    signal timer : integer range 0 to 20 := 0;

    signal main_req : std_logic;
    signal side_req : std_logic;

    constant T_MAIN  : integer := 20;
    constant T_SIDE  : integer := 10;
    constant T_CLEAR : integer := 5;

begin

    main_req <= N_req or S_req;
    side_req <= E_req or W_req;

    process(clk, reset)
    begin
        if reset = '1' then
            state <= IDLE;
            timer <= 0;

        elsif rising_edge(clk) then
            if tick_1s = '1' then

                case state is

                    when IDLE =>
                        timer <= 0;

                        if main_req = '1' then
                            state <= MAIN_SERVICE;
                            timer <= T_MAIN;

                        elsif side_req = '1' then
                            state <= SIDE_SERVICE;
                            timer <= T_SIDE;

                        else
                            state <= IDLE;
                            timer <= 0;
                        end if;


                    when MAIN_SERVICE =>
                        -- Main road continues freely if no side request exists.
                        -- If side road requests, main road countdown starts.
                        if side_req = '1' then
                            if timer = 0 then
                                state <= MAIN_CLEAR;
                                timer <= T_CLEAR;
                            else
                                timer <= timer - 1;
                            end if;
                        else
                            state <= MAIN_SERVICE;
                            timer <= T_MAIN;
                        end if;


                    when MAIN_CLEAR =>
                        -- No grants during clear time.
                        if timer = 0 then
                            if side_req = '1' then
                                state <= SIDE_SERVICE;
                                timer <= T_SIDE;

                            elsif main_req = '1' then
                                state <= MAIN_SERVICE;
                                timer <= T_MAIN;

                            else
                                state <= IDLE;
                                timer <= 0;
                            end if;
                        else
                            timer <= timer - 1;
                        end if;


                    when SIDE_SERVICE =>
                        -- Side road continues freely if no main request exists.
                        -- If main road requests, side road countdown starts.
                        if main_req = '1' then
                            if timer = 0 then
                                state <= SIDE_CLEAR;
                                timer <= T_CLEAR;
                            else
                                timer <= timer - 1;
                            end if;
                        else
                            state <= SIDE_SERVICE;
                            timer <= T_SIDE;
                        end if;


                    when SIDE_CLEAR =>
                        -- No grants during clear time.
                        if timer = 0 then
                            if main_req = '1' then
                                state <= MAIN_SERVICE;
                                timer <= T_MAIN;

                            elsif side_req = '1' then
                                state <= SIDE_SERVICE;
                                timer <= T_SIDE;

                            else
                                state <= IDLE;
                                timer <= 0;
                            end if;
                        else
                            timer <= timer - 1;
                        end if;

                end case;
            end if;
        end if;
    end process;


    process(state, N_req, S_req, E_req, W_req, timer)
    begin
        N_grant <= '0';
        S_grant <= '0';
        E_grant <= '0';
        W_grant <= '0';

        road_code <= "00";
        countdown <= timer;

        case state is

            when MAIN_SERVICE =>
                road_code <= "01";
                N_grant <= N_req;
                S_grant <= S_req;

            when MAIN_CLEAR =>
                road_code <= "01";
                -- clear time: no grant

            when SIDE_SERVICE =>
                road_code <= "10";
                E_grant <= E_req;
                W_grant <= W_req;

            when SIDE_CLEAR =>
                road_code <= "10";
                -- clear time: no grant

            when others =>
                road_code <= "00";

        end case;
    end process;

end Behavioral;
