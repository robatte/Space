shader_type spatial;

uniform sampler2D gradient;
uniform float speed : hint_range(0.1, 10.0);



void fragment() {
	vec4 gradient_color = texture(gradient, vec2(speed * TIME, 0.5));
	ALBEDO *= gradient_color.rgb;
	ALPHA *= gradient_color.a;
}

//void light() {
	// Called for every pixel for every light affecting the material.
	// Uncomment to replace the default light processing function with this one.
//}
