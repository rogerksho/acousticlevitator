// 3DPoint.h

class Point3D {
    public:
        double x;
        double y;
        double z;

        Point3D(double x_in, double y_in, double z_in);

        double calculate_distance(Point3D& other_pt);
};
