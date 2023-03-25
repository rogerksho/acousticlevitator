library verilog;
use verilog.vl_types.all;
entity spi_test is
    port(
        clk             : in     vl_logic;
        rst             : in     vl_logic;
        ss              : in     vl_logic;
        mosi            : in     vl_logic;
        miso            : out    vl_logic;
        sck             : in     vl_logic;
        done            : out    vl_logic;
        dout            : out    vl_logic_vector(7 downto 0)
    );
end spi_test;
