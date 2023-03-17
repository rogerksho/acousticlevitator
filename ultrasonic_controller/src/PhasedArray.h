#include "Point3D.h"
#include <vector>
#include <Arduino.h>

using namespace std;

// RST PIN
const int RST_PIN = 5;

struct Transducer {
    // properties
    Point3D coord; // Point3D
    uint8_t discretized_phase; // discretized (7 bit number) phase
    bool isTop; // top layer or bottom layer

    // ctor
    Transducer();
    Transducer(double x_in, double y_in, double z_in);

    // public member functions
    void calculate_phase(Point3D& focal_point);
    void set_coord(double x_in, double y_in, double z_in);
    void print_coord();
    Point3D calculate_origin();
};
    

class PhasedArray {
    private:
        
    public:
        size_t x_dim;
        size_t y_dim;
        double z_dim;

        double spacing;

        vector<Transducer> transducers; // transducers[row][col], bottom left is origin

        // ctor
        PhasedArray(size_t x_dim_in, size_t y_dim_in, double z_dim_in, double spacing_in);

        void init_array(size_t x_dim, size_t y_dim, double z_dim_in, double spacing = 5.0);
        void make_top_array(double z_height);
        void print_coords();
        void command_point(Point3D& command_in, HardwareSerial& serial_in, bool debug_mode);
        void command_alternating_phase();
        void command_line(Point3D &starting_pt, Point3D &ending_pt, double velocity, bool debug_mode);
        Point3D calculate_origin();
};