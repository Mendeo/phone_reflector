$fn = 50;

reflector(180, 100, 50);

module reflector(width, phoneHeight, phonePlateWidth)
{
	SQRT_2 = sqrt(2);
	d = width - 6; //По 3 мм от края зеркала.
	foilT = 0.8; //Толщина алюминиевой фольги.
	echo("Диаметр зеркала", d);
	dh = 3; //Расстояние от вершины параболы до плоскости основания.
	f = phoneHeight - dh - foilT; //Высота фокуса от вершины
	hp = d * d / (16 * f); //Глубина паболы
	echo("Глубина зеркала", hp);
	height = hp + dh;
	echo("Высота основания", height);
	
	difference()
	{
		translate([-width / 2, -width / 2, 0])
		cube([width, width, height - 0.01]);
		translate([0, 0, height - hp])
		parabolic(d, f);
	}
	wLeg = 3; //Толщина ножки по высоте.
	tLeg = 3; //Толщина ножки в плоскости зеркала.
	//Пластина
	translate([-phonePlateWidth / 2, -phonePlateWidth / 2, phoneHeight - wLeg])
	plate();
	
	legOnMirror();
	mirror([1, 0, 0])
	legOnMirror();
	mirror([0, 1, 0])
	legOnMirror();
	mirror([1, 1, 0])
	legOnMirror();
	
	module legOnMirror()
	{
		translate([-width / 2 + (tLeg / 2) / SQRT_2, -width / 2 + (tLeg / 2) / SQRT_2, height])
		rotate([0, 0, 45])
		leg(wLeg, tLeg, (width - phonePlateWidth) / SQRT_2, phoneHeight - height);
	}
	module plate()
	{
		cube([phonePlateWidth, phonePlateWidth, wLeg]);
		
	}
}

module leg(w, t, x, h)
{
	translate([0, t / 2, 0])
	rotate([90, 0, 0])
	linear_extrude(t)
	polygon([[0, 0], [0, -w], [x, h - w], [x, h], [0, 0]]);
	//polygon([[0, 0], [w * x / h, 0], [0, -w]]);
}
//d - диаметр параболы, f - расстояние до точки фокуса.
module parabolic(d, f)
{
	hp = d * d / (16 * f);
	pPath = concat([for (i = [0 : $fn])
	let (delta = d / (2 * $fn),
		x = i * delta,
		y =  x * x / (4 * f)) [x, y]], [[0, hp]]);

	rotate_extrude()
	{
		polygon(pPath);
	}
}