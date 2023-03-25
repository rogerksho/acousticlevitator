library verilog;
use verilog.vl_types.all;
entity ultrasonic_test is
    generic(
        SCK_DELAY       : integer := 2000;
        SPI_DELAY       : vl_notype
    );
    port(
        clk_tb          : out    vl_logic;
        MOSI            : out    vl_logic;
        transducer_out_test: out    vl_logic_vector(49 downto 0);
        ALL_DONE        : out    vl_logic
    );
    attribute mti_svvh_generic_type : integer;
    attribute mti_svvh_generic_type of SCK_DELAY : constant is 1;
    attribute mti_svvh_generic_type of SPI_DELAY : constant is 3;
end ultrasonic_test;
