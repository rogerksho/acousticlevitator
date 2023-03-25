library verilog;
use verilog.vl_types.all;
entity ultrasonic is
    generic(
        NUM_CHANNELS    : integer := 50
    );
    port(
        master_clock    : in     vl_logic;
        SPI_sclk        : in     vl_logic;
        SPI_mosi        : in     vl_logic;
        SPI_cs          : in     vl_logic;
        rst             : in     vl_logic;
        SPI_data_done   : out    vl_logic;
        apply_shift_all : out    vl_logic;
        transducer_out  : out    vl_logic_vector
    );
    attribute mti_svvh_generic_type : integer;
    attribute mti_svvh_generic_type of NUM_CHANNELS : constant is 1;
end ultrasonic;
