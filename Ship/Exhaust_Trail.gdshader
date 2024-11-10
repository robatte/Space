shader_type spatial;
render_mode blend_add, depth_draw_opaque, cull_back, diffuse_burley, specular_schlick_ggx, shadows_disabled, ambient_light_disabled, fog_disabled;

uniform sampler2D noise;
uniform sampler2D gradient;
uniform float transparency: hint_range(0.01, 1.0, 0.05) = 1.0;
uniform float emission: hint_range(0.0, 5.0, 0.1) = 1.0;

float fresnel(float amount, vec3 normal, vec3 view)
{
	return pow(
		(clamp(dot(normalize(normal), normalize(view)), 0.0, 1.0)),
		amount
	);
}


void fragment() {

	float basic_fresnel = fresnel(2.0, NORMAL, VIEW);
	vec4 pixel = texture(noise, UV * vec2(1, 0.25) + vec2(0, 2.0 * TIME));
	vec4 color = texture(gradient, vec2(UV.y, 0));
	ALBEDO = pixel.rgb * color.rgb;
	EMISSION = ALBEDO * emission;
	ALPHA = pixel.r * pow(UV.y, 1) * pow(basic_fresnel, 2.0) * transparency;

	}
