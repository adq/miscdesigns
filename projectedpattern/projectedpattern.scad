
intersection() {

    difference() {
        translate([0,0,150]) sphere(80);
        translate([0,0,180]) sphere(100);
    }

    linear_extrude(height=200, convexity=20, scale=-2)
        translate([-100,-100])
            difference() {
                square(200,200);

                for(x=[10:10:200-10]) {
                    for(y=[10:10:200-10]) {
                        translate([x-2.5,y-2.5])
                            square(5,5);
                    }
                }
            }
}
