$fn = 360;

width = 180; //Ширина большого квадрата.
phoneHeight = 100; //Высота, на которой должен распологаться телефон.
phonePlateWidth = 50; //Ширина платформы, на которую помещается телефон.
wLeg = 3; //Толщина ножки по высоте и одновременно толщина пластины, на котороую помещается телефон.
tLeg = 3; //Толщина ножки в плоскости зеркала.
wPin = 3; //Ширина пина для удержания телефона.
lPin = 10; //Длина пина для удержания телефона.
hPin = 20; //Высота пина для удержания телефона.
dh = 3; //Расстояние от вершины параболы до плоскости основания.
foilT = 0.8; //Толщина алюминиевой фольги.
mDelta = 3; //Расстояние от края квадрата до параболы.
wStand = 30; //Длина подставки.
lStand = 20; //Насколько подставка выступает над основным квадратом.
hStand = 20; //Высота подставки.
deltaStand = 0.5; //Зазор между основным квадратом и подставкой

SQRT_2 = sqrt(2);
d = width - 2 * mDelta; //Диаметр зеркала.
echo("Диаметр зеркала", d);
f = phoneHeight - dh - foilT; //Высота фокуса от вершины параболы.
hp = d * d / (16 * f); //Глубина паболы.
echo("Глубина зеркала", hp);
height = hp + dh; //Высота основания
echo("Высота основания", height);


reflector();
//twoStands();
//stand();

module twoStands()
{
	translate([-width / 3, 0, 0])
	standTurned();
	translate([width / 3, 0, 0])
	standTurned();
}

module standTurned()
{
	translate([0, -width / 2 - tLeg, 0])
	translate([0, 0, height / 2 + tLeg / 2])
	rotate([-90, 0, 0])
	stand();
}

module reflector()
{
	difference()
	{
		translate([-width / 2, -width / 2, 0])
		cube([width, width, height - 0.01]);
		translate([0, 0, height - hp])
		parabolic(d, f);
	}
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
		Pin();
		translate([phonePlateWidth - lPin, 0, 0])
		Pin();
		/*
		translate([0, phonePlateWidth - wPin, 0])
		Pin();
		translate([phonePlateWidth - lPin, phonePlateWidth - wPin, 0])
		Pin();
		*/
		
		module Pin()
		{
			translate([0, 0, wLeg])
			cube([lPin, wPin, hPin]);
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
}

module stand()
{
	ll = height + 2 * lStand;
	translate([-wStand / 2, -ll / 2, 0])
	union()
	{
		cube([wStand, ll, tLeg]);
		translate([0, lStand - deltaStand - tLeg / 2, 0])
		cube([wStand, tLeg, hStand]);
		translate([0, lStand + height + deltaStand + tLeg / 2, 0])
		cube([wStand, tLeg, hStand]);
	}
	
}