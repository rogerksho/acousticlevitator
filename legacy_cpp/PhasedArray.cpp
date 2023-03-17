#define _USE_MATH_DEFINES

#include "PhasedArray.h"
#include <vector>
#include <cmath>
#include <iostream>

// controller params (SI UNITS)
const double WAVE_SPEED = 343.3; // m/s
const int FREQUENCY = 40000; // Hz
const double WAVE_NUMBER = (2 * M_PI * FREQUENCY)/(WAVE_SPEED);


// Transducer struct implementation
Transducer::Transducer() : coord{0, 0, 0}, phase{0} {} // default ctor
Transducer::Transducer(double x_in, double y_in, double z_in) : coord{x_in, y_in, z_in}, phase{0} {}

void Transducer::calculate_phase(Point3D& focal_point) {
    double distance = coord.calculate_distance(focal_point);
    double distance_rad = -WAVE_NUMBER * distance; // negative phase delay = phase lead

    if (isTop)
        distance_rad += M_PI; // if on top, add pi so antinodes (instead of nodes) are created at focal point

    phase = fmod(distance_rad, 2*M_PI);
}

void Transducer::set_coord(double x_in, double y_in, double z_in) {
    coord.x = x_in;
    coord.y = y_in;
    coord.z = z_in;
}

// PhasedArray class implementation

// init one layer
void PhasedArray::init_array(size_t x_dim, size_t y_dim, double spacing) { // spacing [mm]
    // resize trasnducer 2d vector
    transducers.resize(x_dim); // transducers[row][col], bottom left is origin
    for (auto& v : transducers) {
        v.resize(y_dim);
    }

    // put in coords
    for (size_t i = 0; i < transducers.size(); ++i) {
        for (size_t j = 0; j < transducers[0].size(); ++j) {
            transducers[i][j].set_coord(spacing*i, spacing*j, 0);
        }
    }

    cout << transducers.size() << ',' << transducers[0].size() << endl;
}

// make top layer
void PhasedArray::make_top_array(double z_height) {
    for (size_t i = 0; i < transducers.size(); ++i) {
        for (size_t j = 0; j < transducers[0].size(); ++j) {
            transducers[i][j].isTop = true;
            transducers[i][j].coord.z += z_height;
        }
    }
}

// print coords
void PhasedArray::print_coords() {
    for (size_t i = 0; i < transducers.size(); ++i) {
        for (size_t j = 0; j < transducers[0].size(); ++j) {
           cout << '(' << transducers[i][j].coord.x << ',' 
                       << transducers[i][j].coord.y << ',' 
                       << transducers[i][j].coord.z << ")\n";
        }
    }
}