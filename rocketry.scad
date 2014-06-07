//------------------------------------------------------------------
// Create by Robert F. Nee.  Use freely.
//
// Rocketry related modules
//
//------------------------------------------------------------------


//------------------------------------------------------------------
// Compute y for a given x for a tangent ogive cone in 2D space.
// r - base radius
// p - phi, radius of circle defining cone arc
// x - distance from base of form (not including shoulder)
// returns y which is the radius of the cone at that point

function tan_ogive_y (r, p, x) = sqrt (p * p - x * x) - (p - r); 

//------------------------------------------------------------------
// Draw a tangent ogive cone
// length		- cone length
// diameter	- base diameter
// slice		- number of slices that make up the cone

module tan_ogive_cone (length, diameter, slice)
{
	// height of each slice
	step = length/slice;

	// radius of base of cone
	base_r = diameter/2;

	// Radius of ogive circle
	phi = (base_r * base_r + length * length) / (2 * base_r);

	for (i = [1 : slice]) {
		assign (x = (i - 1) * step) {
			translate ( [0, 0, x] )
			cylinder (
				step,
				tan_ogive_y (base_r, phi, x),
				tan_ogive_y (base_r, phi, x + step)
			);
		}
	}
}

//------------------------------------------------------------------
// Draw a tangent ogive cone with a spherically blunting "cap"
// length		- cone length of UNCAPPED cone
// diameter	- base diameter
// rn		- Radius of nose sphere cap
// slice		- number of slices that make up the cone

module sb_ogive_cone (length, diameter, rn, slice)
{
	// radius of base of cone
	base_r = diameter/2;

	// Radius of ogive circle
	phi = (base_r * base_r + length * length) / (2 * base_r);

	// center of blunting sphere
	x0 = length - sqrt (pow(phi - rn, 2) - pow (phi - base_r, 2));

	// y of tangency point
	yt = rn * (phi - base_r) / (phi - rn);

	// x of tangency point
	xt = x0 - sqrt (rn * rn - yt * yt);

	// height of each slice taking into account the tangency point
	step = (length - xt)/slice;

	for (i = [1 : slice]) {
		assign (x = (i - 1) * step) {
			translate ( [0, 0, x] )
			cylinder (
				step,
				tan_ogive_y (base_r, phi, x),
				tan_ogive_y (base_r, phi, x + step)
			);
		}
	}

	// Nose sphere cap
	translate ([0, 0, length - x0])
		sphere (r = rn);
}

//------------------------------------------------------------------
// Compute y for a given x for a elliptical cone in 2D space.
// l - cone length
// r - base radius
// x - distance from base of form (not including shoulder)
// returns y which is the radius of the cone at that point

function elliptical_y (l, r, x) = r * sqrt (1.0 - (x*x)/(l*l));

//------------------------------------------------------------------
// Draw a eliptical cone of given dimensions
// height		- height of cone not including shoulder
// diameter	- diameter at base of cone
// slice		- number of slices that make up the cone

module elliptical_cone (length, diameter, slice)
{
	// height of each slice
	step = length/slice;

	// radius of base of cone
	base_r = diameter/2;

	for (i = [1 : slice]) {
		assign (x = (i - 1) * step) {
			translate ( [0, 0, x] )
			cylinder (
				step,
				elliptical_y (length, base_r, x),
				elliptical_y (length, base_r, x + step)
			);
		}
	}
}

//------------------------------------------------------------------
// Compute y for a given x for a parabolic cone in 2D space.
// l - cone length
// r - base radius
// k - degree of parabola from 0 (cone) to 1 (full parabola)
// x - distance from base of form (not including shoulder)
// returns y which is the radius of the cone at that point

function parabolic_y (l, r, k, x) = r * sqrt ((2.0 * (x / l) - k * (x*x)/(l*l)) / (2 - k));

//------------------------------------------------------------------
// Draw a parabolic cone of given dimensions
// height		- height of cone not including shoulder
// diameter	- diameter at base of cone
// k			- degree of parabola from 0 (cone) to 1 (full parabola)
// slice		- number of slices that make up the cone

module parabolic_cone (length, diameter, k, slice)
{
	// height of each slice
	step = length/slice;

	// radius of base of cone
	base_r = diameter/2;

	for (i = [1 : slice]) {
		assign (x = (i - 1) * step) {
			translate ( [0, 0, x] )
			cylinder (
				step,
				parabolic_y (length, base_r, k, length - x),
				parabolic_y (length, base_r, k, length - x - step)
			);
		}
	}
}

//------------------------------------------------------------------
// Draw a fin
// thickness	- fin thickness
// root		- lenth of root
// sweep		- length of sweep
// tip		- length of tip
// width		- width of fin

module fin (thickness, root, tip, sweep, width)
{
	rotate ([90, 0, 0])
		linear_extrude (height = thickness)
			polygon (	[
				[0, 0],
				[0, root],
				[width, root - sweep],
				[width, root - sweep - tip],
			] );
}

//------------------------------------------------------------------


