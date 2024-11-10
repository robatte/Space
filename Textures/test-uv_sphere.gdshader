shader_type spatial;

varying vec3 world_position;

void vertex() {
	world_position = normalize(MODEL_MATRIX * vec4(VERTEX, 1.0)).xyz;
}

float hash11(float p) {
 uint u = floatBitsToUint(p * 3141592653.0);
 return float(u * u * 3141592653u) / float(~0u);
}

float hash12(vec2 p) {
 uvec2 u = floatBitsToUint(p * vec2(141421356, 2718281828));
 return float((u.x ^ u.y) * 3141592653u) / float(~0u);
}

uniform sampler2D tex;

void fragment() {
	vec2 uv;
	uv.x = atan(world_position.z, world_position.x) / TAU;
	uv.y = asin(world_position.y) / (PI / 2.0);


	ALBEDO = texture(tex, UV).rgb;
}