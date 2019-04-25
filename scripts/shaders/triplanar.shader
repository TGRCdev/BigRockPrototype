shader_type spatial;

uniform sampler2D albedo : hint_albedo;
uniform sampler2D normal : hint_normal;
uniform sampler2D roughness;
uniform vec4 color : hint_color = vec4(1,1,1,1);
uniform vec2 scale = vec2(1,1);

void fragment()
{
	vec4 mulvert = (CAMERA_MATRIX * vec4(VERTEX, 1.0));
	vec2 x_uv = mulvert.zy;
	vec2 y_uv = mulvert.xz;
	vec2 z_uv = mulvert.xy;
	
	vec4 x_samp = texture(albedo, x_uv * scale);
	vec4 y_samp = texture(albedo, y_uv * scale);
	vec4 z_samp = texture(albedo, z_uv * scale);
	
	vec3 world_norm = normalize(CAMERA_MATRIX * vec4(NORMAL, 0.0)).xyz;
	
	float x_dot, y_dot, z_dot;
	x_dot = abs(dot(world_norm, vec3(1,0,0)));
	y_dot = dot(world_norm, vec3(0,1,0));
	z_dot = abs(dot(world_norm, vec3(0,0,1)));
	
	vec4 result = (x_samp * color * x_dot) + (y_samp * color * abs(y_dot)) + (z_samp * color * z_dot);
	
	ALBEDO = result.rgb;
}