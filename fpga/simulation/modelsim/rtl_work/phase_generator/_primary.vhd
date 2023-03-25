library verilog;
use verilog.vl_types.all;
entity phase_generator is
    generic(
        COUNTS_PER_PERIOD: integer := 128
    );
    port(
        clock_slow      : in     vl_logic;
        clock_out       : out    vl_logic;
        phase_shift     : in     vl_logic_vector(6 downto 0);
        apply_shift     : in     vl_logic
    );
    attribute mti_svvh_generic_type : integer;
    attribute mti_svvh_generic_type of COUNTS_PER_PERIOD : constant is 1;
end phase_generator;
