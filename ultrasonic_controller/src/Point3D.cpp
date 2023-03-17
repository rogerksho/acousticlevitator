#include "Point3D.h"
#include <cstdlib>
#include <math.h>

// millimeter?
Point3D::Point3D(double x_in, double y_in, double z_in) : x{x_in}, y{y_in}, z{z_in} {
}

double Point3D::calculate_distance(Point3D& other_pt) {
    double x_diff = abs(x - other_pt.x);
    double y_diff = abs(y - other_pt.y);
    double z_diff = abs(z - other_pt.z);

    double distance = sqrt(x_diff*x_diff + y_diff*y_diff + z_diff*z_diff);

    return distance;
}

void Point3D::print_coords(HardwareSerial &serial_out) {
    serial_out.print('(');
    serial_out.print(x);
    serial_out.print(", ");
    serial_out.print(y);
    serial_out.print(", ");
    serial_out.print(z);
    serial_out.println(")");
}
