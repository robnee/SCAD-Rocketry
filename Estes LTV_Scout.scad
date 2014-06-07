// Estes LTV Scout K1287
//
// Robert F. Nee
// (c) 2012

// ---------------------------------------------------------------------------
// Settings
// ---------------------------------------------------------------------------
 
// Curve resolution
$fn = 100;

// ---------------------------------------------------------------------------
// Parts Assumptions
// ---------------------------------------------------------------------------

offset = 0;
clearance = 0.01;
shoulder_length = 0.5;
tube_color = "peru";

// ---------------------------------------------------------------------------
// Utility functions
// ---------------------------------------------------------------------------

// ---------------------------------------------------------------------------
// Render a body tube

module body_tube (h, diameter, wall)
{
	difference () {
		cylinder (h=h, r=diameter/2);
		translate ([0,0,-0.01])
		cylinder (h=h + 0.02, r=diameter/2 - wall);
	}
}

// ---------------------------------------------------------------------------
// Render a shoulder based on the dimensions of the tube it fits

module shoulder (h, diameter, wall)
{
	cylinder (h=h, r=diameter/2 - wall - clearance);
}

// ---------------------------------------------------------------------------
// Half round 

module strip (radius, length)
{
	difference () {
		cylinder (length, radius, radius);
		translate ([-radius, -radius/2, -0.01])
		cube ([radius, radius, length + 0.02], false);
	}
}

// ---------------------------------------------------------------------------
// Rounded Cone

module rounded_cone (length, base_radius, tip_radius, wall)
{
	// Compute the angle of that the side of the cone makes with the base.
	// This is the sum of two angles, the angle between the base and a radial
	// from the base corner to the origin of the nose sphere and this radial
	// and the side of the cone.  The total angle can then be used to length
	// of the conical section and the radius at the top of this section.
	t = atan ((length - tip_radius) / base_radius) + 
		asin (tip_radius/sqrt ((length-tip_radius)*(length-tip_radius) + base_radius * base_radius));

	echo (length, length - tip_radius + tip_radius * cos (t), base_radius, tip_radius * sin (t));

	// Draw the cone and sphere using the angle t calculated above	
	union () {
		shoulder (shoulder_length, base_radius * 2, wall);
		translate ([0,0, shoulder_length])
		cylinder (length - tip_radius + tip_radius * cos (t), base_radius,
			 tip_radius * sin (t));
		translate ([0,0, shoulder_length + length - tip_radius])
		sphere (tip_radius);
	}
}

// ---------------------------------------------------------------------------
// Parts for the LTV Scout
// ---------------------------------------------------------------------------

// Parts assumptions
tube1_diam = 1.637;
tube1_wall = 0.021;

tube2_diam = 1.274;
tube2_wall = 0.021;

tube3_diam = 1.228;
//tube3_diam = 1.214; // T52H
tube3_wall = 0.023;

tube4_diam = 1.389;
tube4_wall = 0.022;

// ---------------------------------------------------------------------------

// Tube 1
module bt_60kc ()
{
	color (tube_color)
	body_tube (12.84, tube1_diam, tube1_wall);
}

module sbt_127gc ()
{
	color (tube_color)
	body_tube (7.26, tube2_diam, tube2_wall);
}

module sbt_123be ()
{
	color (tube_color)
	body_tube (2.5, tube3_diam, tube3_wall);
}

module sbt_139bj ()
{
	color (tube_color)
	body_tube (2.0, tube4_diam, tube4_wall);
}

// ---------------------------------------------------------------------------
// Nose cones and transitions

module pta_1287_2 ()
{
	// Length: 2.396

	color ("white")
	difference () {
		union () {
			shoulder (shoulder_length, tube1_diam, tube1_wall);
			translate ([0,0, shoulder_length])
			cylinder (h=0.395, r=tube1_diam/2);
			translate ([0,0, shoulder_length + 0.395])
			cylinder (2.001, tube1_diam/2, tube2_diam/2);
			translate ([0,0, shoulder_length + 0.395 + 2.001])
			shoulder (shoulder_length, tube2_diam, tube2_wall);
		}

		// Core
		translate([0,0,-0.01])
		cylinder (shoulder_length*2 + 0.395 + 2.001 + 0.02,
				(tube1_diam - 0.2)/2, (tube2_diam - 0.2)/2); 
	}
}

// Lower fin base

module pta_1287_1 ()
{
	// Length: 1.556

	color ("white")
	difference () {
		union () {
			cylinder (h=1.556, r=tube1_diam/2)
			translate ([0,0, 1.556])
			shoulder (shoulder_length, tube1_diam, tube1_wall);
		}

		// Motor Tube
		translate([0,0,-0.01])
		cylinder (1.556 + shoulder_length + 0.02, 0.736/2 - clearance, 0.736/2 - clearance);
	}
}

// ---------------------------------------------------------------------------

module pnc_1287_1 ()
{
	// Length: 2.501

	color ("white")
	difference () {
		union () {
			shoulder (shoulder_length, tube2_diam, tube2_wall);
			translate ([0,0, shoulder_length])
			cylinder (h=0.609, r=tube2_diam/2);
			translate ([0,0, shoulder_length + 0.609])
			cylinder (1.892, tube2_diam/2, tube3_diam/2);
			translate ([0,0, shoulder_length + 0.609 + 1.892])
			shoulder (shoulder_length, tube3_diam, tube3_wall);
		}
		translate([0,0,-0.01])
		cylinder (shoulder_length*2 + 0.609 + 1.892 + 0.02, (tube2_diam - 0.2)/2, (tube3_diam - 0.2)/2); 
	}
}

module pnc_1287_2 ()
{
	// Length: 3.198

	color ("white")
		union () {
			shoulder (shoulder_length, tube3_diam, tube3_wall);
			translate ([0,0, shoulder_length])
			cylinder (1.126, tube3_diam/2, 1.052/2);
			translate ([0,0, shoulder_length + 1.126])
			cylinder (2.072, 1.052/2, tube4_diam/2);
			translate ([0,0, shoulder_length + 1.126 + 2.072])
			shoulder (shoulder_length, tube4_diam, tube4_wall);
		}
}

// Nose cone

module pnc_1287_3 ()
{
	// Length: 1.195

	color ("white")
	rounded_cone (1.195, tube4_diam/2, 0.316, 0.022);
}

module fin ()
{
	polyhedron (
		points = [
			[0, 0.207/2, 0],
			[1.473, 0, 0],
			[0, 0, 1.457],
			[0, -0.207/2, 0]
		],
		triangles = [
			[0, 1, 2],
			[0, 1, 3],
			[0, 2, 3],
			[3, 1, 2]
		]
	);
}

module conduit (h)
{
	color ("white")
	strip (0.25/2, h);
}


// ---------------------------------------------------------------------------

module ltv_scout ()
{
	pta_1287_1 ();
	translate ([0,0,1.556])
	bt_60kc (); 
	translate ([0,0,1.556 + 12.84 - shoulder_length])
	pta_1287_2 ();
	translate ([0,0,1.556 + 12.84 + 2.396])
	sbt_127gc ();
	translate ([0,0,1.556 + 12.84 + 2.396 + 7.26 - shoulder_length])
	pnc_1287_1 ();
	translate ([0,0,1.556 + 12.84 + 2.396 + 7.26 + 2.501])
	sbt_123be ();
	translate ([0,0,1.556 + 12.84 + 2.396 + 7.26 + 2.501 + 2.5 - shoulder_length])
	pnc_1287_2 ();
	translate ([0,0,1.556 + 12.84 + 2.396 + 7.26 + 2.501 + 2.5 + 3.198])
	sbt_139bj ();
	translate ([0,0,1.556 + 12.84 + 2.396 + 7.26 + 2.501 + 2.5 + 3.198 + 2.00 - shoulder_length])
	pnc_1287_3 ();

	// Wiring conduits
	rotate ([0, 0, 45])
	translate ([tube1_diam/2, 0, 1.2])
	conduit (24);

	rotate ([0, 0, 135])
	translate ([tube1_diam/2, 0, 1.2])
	conduit (28);


	// Fins
	for (i = [0 : 3]) {
		rotate ([0, 0, i* 90])
		translate ([tube1_diam/2, 0, -0.354])
		fin ();
	}
}

ltv_scout ();

