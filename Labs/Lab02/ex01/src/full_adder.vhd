entity full_adder is
    port(
        a, b, cin : in bit;
        s, cout   : out bit
    );
end full_adder;

architecture structural of full_adder is

    component half_adder is
        port(
            a, b : in bit;
            s, co : out bit
        );
    end component;

    signal s1  : bit;
    signal co1 : bit;
    signal co2 : bit;

begin

    HA1: half_adder
        port map(
            a  => a,
            b  => b,
            s  => s1,
            co => co1
        );

    HA2: half_adder
        port map(
            a  => s1,
            b  => cin,
            s  => s,
            co => co2
        );

    cout <= co1 or co2;

end structural;
