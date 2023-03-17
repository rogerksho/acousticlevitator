#include "PhasedArray.h"
#include <iostream>

using namespace std;

int main(int argc, char** argv) {
    Point3D a(1, 2, 3);
    Point3D b(2, 2, 9);

    cout << argc << argv << endl;
    cout << a.calculate_distance(b) << endl;

    PhasedArray top;
    PhasedArray bot;

    top.init_array(5, 5);
    bot.init_array(5, 5);

    top.print_coords();
}