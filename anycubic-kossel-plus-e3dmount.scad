
housing_width=15;
housing_height=40;
housing_length=40;

hotend_buffer=0;
screw_size=3;
screw_length=8;
airflow_radius=9;


debug=0;

module chamfercube(xyz=[0,0,0],side=[0,0,0,0],top=[0,0,0,0],bottom=[0,0,0,0],x=false,y=false,z=false) {
	translate([x==true?-xyz[0]/2:0,y==true?-xyz[1]/2:0,z==true?-xyz[2]/2:0]) difference() {
		cube(xyz);
		if(side[0]>=0) translate([0,0,xyz[2]/2]) rotate([0,0,45]) cube([side[0]*2,side[0]*3,xyz[2]+2],center=true);
		if(side[1]>=0) translate([xyz[0],0,xyz[2]/2]) rotate([0,0,-45]) cube([side[1]*2,side[1]*3,xyz[2]+2],center=true);
		if(side[2]>=0) translate([xyz[0],xyz[1],xyz[2]/2]) rotate([0,0,45]) cube([side[2]*2,side[2]*3,xyz[2]+2],center=true);
		if(side[3]>=0) translate([0,xyz[1],xyz[2]/2]) rotate([0,0,-45]) cube([side[3]*2,side[3]*3,xyz[2]+2],center=true);
		if(top[0]>=0) translate([xyz[0]/2,0,xyz[2]]) rotate([-45,0,0]) cube([xyz[0]+2,top[0]*2,top[0]*3,],center=true);
		if(top[2]>=0) translate([xyz[0]/2,xyz[1],xyz[2]]) rotate([45,0,0]) cube([xyz[0]+2,top[2]*2,top[2]*3,],center=true);
		if(top[3]>=0) translate([0,xyz[1]/2,xyz[2]]) rotate([0,45,0]) cube([top[3]*2,xyz[1]+2,top[3]*3,],center=true);
		if(top[1]>=0) translate([xyz[0],xyz[1]/2,xyz[2]]) rotate([0,-45,0]) cube([top[1]*2,xyz[1]+2,top[1]*3,],center=true);
		if(bottom[0]>=0) translate([xyz[0]/2,0,0]) rotate([45,0,0]) cube([xyz[0]+2,bottom[0]*2,bottom[0]*3,],center=true);
		if(bottom[2]>=0) translate([xyz[0]/2,xyz[1],0]) rotate([-45,0,0]) cube([xyz[0]+2,bottom[2]*2,bottom[2]*3,],center=true);
		if(bottom[3]>=0) translate([0,xyz[1]/2,0]) rotate([0,-45,0]) cube([bottom[3]*2,xyz[1]+2,bottom[3]*3,],center=true);
		if(bottom[1]>=0) translate([xyz[0],xyz[1]/2,0]) rotate([0,45,0]) cube([bottom[1]*2,xyz[1]+2,bottom[1]*3,],center=true);
	}	
}

module fncylinder(r,r2,h,fn){

	if (fn==undef) {
		if (r2==undef) {
			cylinder(r=r,h=h,$fn=2*r*3.14/fnresolution);
		} else {
			cylinder(r=r,r2=r2,h=h,$fn=2*r*3.14/fnresolution);
		}
	} else {
		if (r2==undef) {
			cylinder(r=r,h=h,$fn=fn);
		} else {
			cylinder(r=r,r2=r2,h=h,$fn=fn);
		}
	}
}


module stolen_hotend() {

	if (debug) { 

	// hotend
	translate([0,20,39]) {
		rotate([0,180,0]) {
			// print_part();
		}
	}

	}
}

module housing_body_right() {
	//cube(size=[housing_width,housing_length,housing_height]);
	
	$fn=24;
   chamfercube([housing_width,housing_length,housing_height],
				 side=[0.6,0.6,0.6,0.6],
				 top=[0.6,0.6,0.6,0.6],
				 bottom=[0.6,0.6,0.6,0.6]);

}

module mock_hotend() {

	// Countersink at top.
	translate([0,housing_length / 2.0,housing_height-2]) {
		cylinder(h = 2.5, 
					r1 = 7 + hotend_buffer, 
					r2 = 10 + hotend_buffer, center = true/false);
	}
	
	translate([0,20,40]) {
		rotate([0,180,0]) {
			translate([0,0,0])  fncylinder(r=8,h=7);
			translate([0,0,6])  fncylinder(r=6,h=8);
			translate([0,0,13]) fncylinder(r=8,h=8);
			translate([0,0,20]) fncylinder(r=11.15,h=26);
			translate([0,0,0])  fncylinder(r=8,h=7);
			translate([0,0,45]) fncylinder(r=2,h=4.1);
			translate([-8,-4.5,48.1]) chamfercube([16,20,11.5],side=[0.4,0.4,0.4,0.4],top=[0.4,0.4,0.4,0.4],bottom=[0.4,0.4,0.4,0.4]);
			translate([0,0,58.6]) fncylinder(r=2.5,h=3);
			translate([0,0,60.6]) fncylinder(r=4.03,h=3,fn=6);
			translate([0,0,62.6]) fncylinder(r=3,r2=0.5,h=3);
		}
	}

}


module hotend_airflow_holes() {

	// main airflow exit,i guess.
	translate([0,40,10]) { 
		rotate([90,0,0]) { 
			fncylinder(r=airflow_radius,h=40); 
		}
	}


	// chamfer on the right air intake.
	translate([0,3.5,10]) {
		rotate([90,0,0]) {
			cylinder(h=4,r1=7,r2=11);
		}
	}


	// chamfer on the right air intake.
	translate([0,36.5,10]) {
		rotate([270,0,0]) {
			cylinder(h=4,r1=7,r2=11);
		}
	}


}


module effector_bolt_holes() {

	hole_offset = 3.5;

	// bottom right hole

	translate([9,hole_offset,0]) {
		rotate([0,0,0]) {
			fncylinder(r= screw_size/2.0,h=screw_length);
		}
	}

	// bottom right hole.

	translate([9,housing_length - hole_offset,0]) {
		rotate([0,0,0]) {
			fncylinder(r= screw_size/2.0,h=screw_length);
		}
	}

}

module right_fan_screw_holes() {
	echo("TODO: FAN BOLTS");
	
	fan_screw_size=2;
	offset=2.75;

	translate([7,offset,offset]) {
		rotate([0,90,0]) {
			fncylinder(r=fan_screw_size/2.0,h=screw_length);
		}
	}

	
	translate([7,housing_length-offset,offset]) {
		rotate([0,90,0]) {
			fncylinder(r=fan_screw_size/2.0,h=screw_length);
		}
	}


	translate([7,offset,housing_height - offset]) {
		rotate([0,90,0]) {
			fncylinder(r=fan_screw_size/2.0,h=screw_length);
		}
	}

	
	translate([7,housing_length-offset,housing_height - offset]) {
		rotate([0,90,0]) {
			fncylinder(r=fan_screw_size/2.0,h=screw_length);
		}
	}




}

module right_bracing_bolts() {
	echo("TODO: BRACING BOLTS");

	hole_edge_offset=4;

	bolt_hole_size=2;
	bolt_head_size=4;

	// reminder: build subset.

	// right hole
	translate([housing_width + 0.1,hole_edge_offset,25]) {
		rotate([0,270,0]) {
			// bolt hole
			fncylinder(r=bolt_hole_size/2.0,h=housing_width+1);

			// subset bot head.
			fncylinder(r=bolt_head_size/2.0,h=3);

		}
	}


	// right hole
	translate([housing_width + 0.1,housing_length - hole_edge_offset,25]) {
		rotate([0,270,0]) {
			// bolt hole
			fncylinder(r=bolt_hole_size/2.0,h=housing_width+1);

			// subset bot head.
			fncylinder(r=bolt_head_size/2.0,h=3);

		}
	}

}

module side() {

	difference() {
		housing_body_right();
		mock_hotend();
		hotend_airflow_holes();
		effector_bolt_holes();
		right_fan_screw_holes();
		right_bracing_bolts();
	}

}

module right_side() {

	side();
}

module left_side() {

	translate([0,housing_length,0]) {
		rotate([0,0,180]) {

			difference() {
				side();

				translate([20,20,20]) { 
					sphere($fn = 36, $fa = 6, $fs = 12, r = housing_width - 1);
				}
			}
		}
	}
}

module print_part() {
	left_side();
	right_side();
}


print_part();
