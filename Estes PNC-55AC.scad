//------------------------------------------------------------------
// Create by Robert F. Nee.  Use freely.
//
// See http://en.wikipedia.org/wiki/Nose_cone_design#Secant_ogive for more info
//
// Estes PNC-55AC (Nike-X, Cherokee-D etc.)
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

//------------------------------------------------------------------
// Parameter definitions for Estes PNC-55AC.  Tweak these for different shapes.
// The value of phi was determined empirically and may not be 100 accurate
// It looks OK to my eye.  It you have better info please share it.

$fn = 60; 			// Number of fragments used to generate circles
h = 5.403;			// Height in inches
od = 1.325;			// OD of base of cone in inches
id = 1.283 - 0.002;		// ID of BT-55 plus some room for shoulder
phi = 33;				// radius of circle defining curve
sh = 0.5;				// Height of shoulder in inches

// shoulder
cylinder (h=sh, d=id);
translate ([0, 0, sh])
	sec_ogive (h, od, phi, 20);
