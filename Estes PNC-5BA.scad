//------------------------------------------------------------------
// Create by Robert F. Nee.  Use freely.
//
// See http://en.wikipedia.org/wiki/Nose_cone_design#Secant_ogive for more info
//
// Estes PNC-5BA (Mini Bomarc, Mars Snooper etc.)
//
//------------------------------------------------------------------

//------------------------------------------------------------------
// Compute y for a given x for a secant ogive in 2D space.
// a - alpha
// p - phi
// x - distance from base of form (not including shoulder)
// returns y which is the radius of the cone at that point

function sec_ogive_y (a, p, x) =
	max(sqrt (p * p - pow (p * cos (a) - x, 2)) + p * sin (a), 0); 

//------------------------------------------------------------------
// Draw a secant ogive cone of given dimensions
// height		- height of cone not including shoulder
// diameter	- diameter at base of cone
// phi		- radius of circle that defines the curve of the cone 
// slice		- number of slices that make up the cone

module sec_ogive (height, diameter, phi, slice)
{
	// height of each slice
	step = height/slice;

	// radius of base of cone
	base_r = diameter/2;

	// alpha (see web page above)
	alpha = atan (base_r/height) - 
			acos (sqrt (height*height + base_r*base_r)/(2*phi));

//echo (alpha, phi, h2, 2*sec_ogive_y (alpha, phi, height - h2) );

	// generate slices as a series of truncated cones
	for (i = [1 : slice]) {
		// x is location of base of slice
		assign (x = (i - 1) * step) {
			// position slice
			translate ( [0, 0, x] )
			// draw slice (truncated cone)
			cylinder (
				step,
				sec_ogive_y (alpha, phi, height - x),
				sec_ogive_y (alpha, phi, height - x - step)
			);
		}
	}
}

// BT5	0.515
// BT20	0.736

//------------------------------------------------------------------
// Parameter definitions for Estes PNC-5BA.  Tweak these for different shapes.
// The value of phi was determined empirically and may not be 100 accurate
// It looks OK to my eye.  It you have better info please share it.
// The cone is composited out of a clipped secant ogive topped by an inset
// cone.

					// Dimension are in inches
$fn = 60; 			// Number of fragments used to generate circles
h1 = 3.0;			// Height of ogive
h2 = 0.382;			// Clipping height
cd = 0.345;			// Topping cone base diameter
ch = 0.210;			// Topping cone height
od = 0.541;			// OD of base of cone in inches
id = 0.515 - 0.002;		// ID of BT-55 plus some room for shoulder
phi = 33;				// radius of circle defining curve
sh = 0.25;				// Height of shoulder in inches

// shoulder
cylinder (h=sh, d=id);

// Clipped ogive
translate ([0, 0, sh])
difference () {
	sec_ogive (h1, od, phi, 20);
	translate ([0, 0, h2])
		cylinder (h=h1, d=od);
}

// Topping cone
translate ([0, 0, sh + h2])
	cylinder (h=ch, d1=cd, d2=0.01);

