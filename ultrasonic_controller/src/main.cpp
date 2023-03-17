#include <Arduino.h>
#include <PhasedArray.h>
#include <SPI.h>

// thickness vars
const double pcb_bottom_to_source_dist = 7; // [mm]
const double pcb_thickness = 1.6; // [mm]

// pcb bottom to pcb bottom dist
double pcb_top_to_top_dist = 89.5; // [mm]
double pcb_bottom_to_bottom_dist = pcb_top_to_top_dist + 2*pcb_thickness; // [mm]
double source_to_source_dist = pcb_bottom_to_bottom_dist - 2*pcb_bottom_to_source_dist; // [mm]

// init phased array
PhasedArray arr(5, 5, source_to_source_dist, 20.0); // init_array(size_t x_dim_in, size_t y_dim_in, double z_dim_in, double spacing_in) [mm]

void setup() {
  // put your setup code here, to run once:
  pinMode(LED_BUILTIN, OUTPUT);
  pinMode(RST_PIN, OUTPUT);
  digitalWrite(RST_PIN, LOW);

  Serial.begin(115200);
  SPI.begin();

  //SPI.setFrequency(5000000); // 5 MHz SPI
}

// init points
Point3D line_start = arr.calculate_origin();
Point3D line_end = Point3D(line_start.x - 10, line_start.y, line_start.z);

void loop() {
  //arr.command_alternating_phase();
  Point3D origin = arr.calculate_origin();
  origin.print_coords(Serial);

  arr.command_point(origin, Serial, false);
  delay(1000);

  if (Serial.available()) {
    // eat up all buffer
    while(Serial.available() > 0) {
      char t = Serial.read();
    }
    arr.command_line(line_start, line_end, 1, false);
    arr.command_line(line_end, line_start, 1, false);
  }

}