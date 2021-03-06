// iTopie RepRap - Triangle
//
// @version 1.0.1
// @license GPLv3
// @docs    http://reprap.org/wiki/ITopie  
// @sources https://github.com/lautr3k/RepRap-iTopie 
// @author  Sébastien Mischler <skarab>
// @author  http://www.onlfait.ch
//
include <../config.scad>
use     <../shapes.scad>

// triangle connectors
module triangle_connectors() {
    translate([-triangle_connectors_size[0], 20, 0])
        square(triangle_connectors_size);
    translate([-triangle_connectors_size[0], (_triangle_height - 20 + triangle_connectors_size[1]) / 2, 0])
        square(triangle_connectors_size);
    translate([-triangle_connectors_size[0], _triangle_height - triangle_connectors_size[1], 0])
        square(triangle_connectors_size);
    translate([_triangle_width - triangle_connectors_size[1] - triangle_connectors_margin[0], -triangle_connectors_size[0], 0])
        square([triangle_connectors_size[1], triangle_connectors_size[0]]);
}

// rear triangle
module triangle_base(width, height, angle) {
    render() difference() {
        square([width, height]);
        translate([width, 0, 0])
            rotate([0, 0, angle])
                square([width * 2, height * 2]);
    }
}

module triangle_corner(){
    render() difference() {
        minkowski() {
            offset(-triangle_radius)
                triangle_base(_triangle_width, _triangle_height, _triangle_angle);
            circle(triangle_radius);
        }
        square([_triangle_width, _triangle_height / 2]);
        square([triangle_radius, _triangle_height]);
    }
}

// triangle
module triangle_2D() {
    translate([triangle_connectors_size[0], triangle_connectors_size[0], 0]) {
        render() difference() {
            triangle_base(_triangle_width, _triangle_height, _triangle_angle);
            translate([triangle_radius, _triangle_height / 2, 0])
                square([_triangle_width, _triangle_height / 2]);
        }
        triangle_corner();
        triangle_connectors();
    }
}

module triangle_3D() {
    linear_extrude(sheet_thickness)
        triangle_2D();
}

module triangle() {
    // 0 : 2D preview (default)
    // 1 : extruded view
    // 2 : export first layer
    // 3 : export second layer (pockets)
    if (output_mode == 0) {
        triangle_2D();
    } 
    else if (output_mode == 1) {
        triangle_3D();
    } 
    else if (output_mode == 2) {
        triangle_2D();
    } 
    else if (output_mode == 3) {
    } 
    else {
        triangle_3D();
    }
}

triangle();
