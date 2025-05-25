shader_type canvas_item;

uniform vec4 addcolor:source_color;
uniform vec4 target:source_color;

void vertex() {
	// Called for every vertex the material is visible on.
}

void fragment()
{
	if (distance(COLOR, target) < 0.05)
	{
		COLOR = mix(COLOR,addcolor,abs(sin(TIME * 5.0)));
	}
}

//void light() {
//	// Called for every pixel for every light affecting the CanvasItem.
//	// Uncomment to replace the default light processing function with this one.
//}
