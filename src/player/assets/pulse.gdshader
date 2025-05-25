shader_type canvas_item;

uniform vec4 addcolor:source_color;
uniform float factor = 0.0;

void vertex() {
	// Called for every vertex the material is visible on.
}

void fragment()
{
	if (COLOR.r > 0.2)
	{
		COLOR = mix(COLOR,addcolor,factor);
	}
}

//void light() {
//	// Called for every pixel for every light affecting the CanvasItem.
//	// Uncomment to replace the default light processing function with this one.
//}
