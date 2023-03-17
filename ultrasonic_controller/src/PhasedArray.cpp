#define _USE_MATH_DEFINES

#include "PhasedArray.h"
#include <vector>
#include <cmath>
#include <iostream>
#include <Arduino.h>
#include <SPI.h>
#include <queue>

// controller params (SI UNITS)
const double WAVE_SPEED = 343.3*1000; // mm/s
const double FREQUENCY = 39062.5; // Hz
const double WAVE_NUMBER = (2.0 * M_PI * FREQUENCY)/(WAVE_SPEED); // rad/mm

// Transducer struct implementation
Transducer::Transducer() : coord{0, 0, 0}, discretized_phase{0} {} // default ctor
Transducer::Transducer(double x_in, double y_in, double z_in) : coord{x_in, y_in, z_in}, discretized_phase{0} {}

void Transducer::calculate_phase(Point3D& focal_point) {
    double distance = coord.calculate_distance(focal_point); // [mm]
    double distance_rad = -WAVE_NUMBER * distance;

    if (isTop)
        distance_rad += M_PI; // if on top, add pi so antinodes (instead of nodes) are created at focal point

    double desired_phase = fmod(distance_rad, 2*M_PI); // the result of this is negative

    // round and discretize
    discretized_phase = round(desired_phase / (M_PI/64)); // assigned to a uint8, will add UINT_MAX+1 until positive
                                                          // however its alright because UINT_MAX+1 = 256 is 2 full periods
                                                          // so phase information is preserved
}

void Transducer::print_coord() {
    cout << "x: " << coord.x << " y: " << coord.y << " z: " << coord.z << endl;
}

void Transducer::set_coord(double x_in, double y_in, double z_in) {
    coord.x = x_in;
    coord.y = y_in;
    coord.z = z_in;
}

// PhasedArray class implementation
PhasedArray::PhasedArray(size_t x_dim_in, size_t y_dim_in, double z_dim_in, double spacing_in) {
    init_array(x_dim_in, y_dim_in, z_dim_in, spacing_in);
}

// init both layers
void PhasedArray::init_array(size_t x_dim_in, size_t y_dim_in, double z_dim_in, double spacing_in) { // spacing_in [mm]
    // save dims
    x_dim = x_dim_in;
    y_dim = y_dim_in;
    z_dim = z_dim_in;

    spacing = spacing_in;

    // resize trasnducer 2d vector
    transducers.resize(x_dim_in*y_dim_in);

    // put in coords
    for (size_t j = 0; j < transducers.size(); j++) {
        transducers[j].set_coord((j % x_dim)*spacing_in, int(j / x_dim)*spacing_in, 0);
        transducers[j].discretized_phase = 0;
    }

    make_top_array(z_dim_in);
}

// make top layer
void PhasedArray::make_top_array(double z_height) {
    vector<Transducer> top_transducers_temp(transducers);

    for (size_t i = 0; i < top_transducers_temp.size(); ++i) {
        top_transducers_temp[i].isTop = true;
        top_transducers_temp[i].coord.z += z_height;
    }

    transducers.insert(transducers.end(), top_transducers_temp.begin(), top_transducers_temp.end());
}

// calculate origin
Point3D PhasedArray::calculate_origin() {
    double center_x = (spacing * (double(x_dim) - 1))/2;
    double center_y = (spacing * (double(y_dim) - 1))/2;
    double center_z = double(z_dim)/2;

    return Point3D(center_x, center_y, center_z);
}

// print coords
void PhasedArray::print_coords() {
    for (size_t i = 0; i < transducers.size(); ++i) {
           cout << '(' << transducers[i].coord.x << ',' 
                       << transducers[i].coord.y << ',' 
                       << transducers[i].coord.z << ")\n";
    }
}

// command point
void PhasedArray::command_point(Point3D& command_in, HardwareSerial& serial_in, bool debug_mode=false) {
    for (auto& tran : transducers) {
        tran.calculate_phase(command_in);
    }

    // send reset pulse
    digitalWrite(RST_PIN, HIGH);
    digitalWrite(RST_PIN, LOW);

    for (auto& tran : transducers) {
        if (debug_mode)
            serial_in.println(tran.discretized_phase);
        else
            SPI.transfer(tran.discretized_phase);
    }
}

// command alternating phase
void PhasedArray::command_alternating_phase() {
    for (size_t i = 0; i < transducers.size(); ++i) {
        if (i % 2 == 0) {
             SPI.transfer(0);
        }
        else {
             SPI.transfer(64);
        }
    }
}

// command to move a line
void PhasedArray:: command_line(Point3D& starting_pt, Point3D& ending_pt, double velocity, bool debug_mode=false) { // velocity in mm/s
    // params
    double PATH_RESOLUTION = 0.1; // [mm]
    queue<Point3D> point_path;
    int calculated_delay = (PATH_RESOLUTION/velocity)*1000;

    double line_length = starting_pt.calculate_distance(ending_pt);
    int divisor = line_length/PATH_RESOLUTION;

    double x_inc = (ending_pt.x - starting_pt.x)/divisor;
    double y_inc = (ending_pt.y - starting_pt.y)/divisor;
    double z_inc = (ending_pt.z - starting_pt.z)/divisor;

    // emplace points
    for (int i = 0; i < divisor; ++i) {
        point_path.emplace(starting_pt.x + x_inc*i, starting_pt.y + y_inc*i, starting_pt.z+z_inc*i);
    }
    
    // emplace last point from rounding
    point_path.push(ending_pt);

    if (debug_mode) {
        // queue everything
        while (!point_path.empty()) {
            point_path.front().print_coords(Serial);
            point_path.pop(); // pop
            delay(calculated_delay); // delay in millisecs
        }
    }
    else {
        // queue everything
        while (!point_path.empty()) {
            command_point(point_path.front(), Serial, false); // command point
            point_path.pop(); // pop
            delay(calculated_delay); // delay in millisecs
        }
    }

}