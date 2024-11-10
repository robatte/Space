// NOTE: Shader automatically converted from Godot Engine 4.4.dev3's StandardMaterial3D.

shader_type spatial;
render_mode blend_mix, depth_draw_opaque, cull_back, diffuse_burley, specular_schlick_ggx, depth_test_disabled, ambient_light_disabled, fog_disabled;

uniform vec4 albedo : source_color;
uniform sampler2D emission_gradient;
uniform sampler2D noise_texture_low;
uniform sampler2D noise_texture_mid;
uniform sampler2D noise_texture_hi;
uniform float speed: hint_range(0.0, 1.0, 0.01) = 1.0;

uniform float rim : hint_range(0.0, 1.0, 0.01);
uniform float rim_tint : hint_range(0.0, 1.0, 0.01);
uniform sampler2D texture_rim : hint_default_white, filter_linear_mipmap, repeat_enable;

void vertex() {
}

void fragment() {
	vec2 uv1 = vec2(UV.x + TIME * speed, UV.y);
	vec2 uv2 = vec2(UV.x - TIME * speed, UV.y);
	vec2 uv3 = vec2(UV.x, UV.y + TIME * speed);

	float noise_low = 1.0;
	float noise_mid = 1.0;
	float noise_hi = 1.0;

	noise_low = texture(noise_texture_low, uv1).r;
	noise_mid = texture(noise_texture_mid, uv2).r;
	noise_hi = texture(noise_texture_hi, uv3).r;

	vec3 new_color = vec3(noise_low, noise_mid, noise_hi);
	float new_alpha = noise_low * noise_mid * noise_hi;

	EMISSION = vec3(new_alpha) * albedo.rgb * 9.0;
	ALBEDO = vec3(new_alpha) * albedo.rgb;

	//ALPHA = new_alpha * 10.0;

	// Rim: Enabled
	vec2 rim_tex = texture(texture_rim, UV).xy;
	RIM = rim * rim_tex.x;
	RIM_TINT = rim_tint * rim_tex.y;
}
