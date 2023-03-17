#include "Point3D.h"
#include <vector>

using namespace std;

struct Transducer {
    // properties
    Point3D coord; // Point3D
    double phase; // rad
    bool isTop; // top layer or bottom layer

    // ctor
    Transducer();
    Transducer(double x_in, double y_in, double z_in);

    // public member functions
    void calculate_phase(Point3D& focal_point);
    void set_coord(double x_in, double y_in, double z_in);
};
    

class PhasedArray {
    public:
        vector<vector<Transducer>> transducers; // transducers[row][col], bottom left is origin

        void init_array(size_t x_dim, size_t y_dim, double spacing = 5.0);
        void make_top_array(double z_height);
        void print_coords();
};