shader_type spatial;
render_mode world_vertex_coords;
render_mode cull_disabled;

uniform float expansion_max = 0.2;

uniform float transition_in : hint_range(-1.0, 1.0) = -0.5;
uniform float transition_out : hint_range(-1.0, 1.0) = 0.5;
uniform vec4 surface_albedo : source_color = vec4(1);
uniform vec4 emission: source_color = vec4(0);
uniform float metallic: hint_range(0.0, 1.0) = 0.0;
uniform float roughness: hint_range(0.0, 1.0) = 1.0;
uniform sampler3D dissolve_noise_texture;
uniform sampler3D hue_noise_texture;

// Variables set by code
uniform vec3 intersector_pos = vec3(0,0,0);
uniform float intersector_radius = 0.0;
//uniform vec4 p_vec = vec3(0,0,0);
//uniform vec3 b_vec = vec3(0,0,0);

// Box SDF from https://iquilezles.org/articles/distfunctions/
//float sdBox(vec3 p, vec3 b )
//{
  //vec3 q = abs(p) - b;
  //return length(max(q,0.0)) + min(max(q.x,max(q.y,q.z)),0.0);
//}

// Sphere SDF function from https://iquilezles.org/articles/distfunctions/
float sphereDst(vec3 pos, vec3 centre, float radius) {
	return length(pos - centre) - radius;
}

void vertex() {
	// Use the intersector's distance to scale the vertex displacement along the normal direction
	float dst = sphereDst(VERTEX, intersector_pos, intersector_radius);
	//float dst = sdBox()
	VERTEX = VERTEX + NORMAL * expansion_max * (1.0 - smoothstep(transition_in, transition_out, dst));
}

// Taken from https://stackoverflow.com/questions/15095909/from-rgb-to-hsv-in-opengl-glsl
// All components are in the range [0…1], including hue.
vec3 hsv2rgb(vec3 c)
{
    vec4 K = vec4(1.0, 2.0 / 3.0, 1.0 / 3.0, 3.0);
    vec3 p = abs(fract(c.xxx + K.xyz) * 6.0 - K.www);
    return c.z * mix(K.xxx, clamp(p - K.xxx, 0.0, 1.0), c.y);
}

void fragment() {
	vec4 pos_world = INV_VIEW_MATRIX * vec4(VERTEX, 1.0);
	float dissolve_noise = texture(dissolve_noise_texture, pos_world.xyz).r;
	ALBEDO = surface_albedo.xyz;
	METALLIC = metallic;
	EMISSION = emission.xyz;
	ROUGHNESS = roughness;
	//ALPHA = surface_albedo.a;
	// Use the intersector distance to transition in the dissolve effect
	float dst = sphereDst(pos_world.xyz, intersector_pos, intersector_radius);
	float cutoff = 1.0 - smoothstep(transition_in, transition_out, dst);
	if (dissolve_noise < cutoff)
	{
		discard;
	}

	// For backfaces change the colour, this could be any colour but I just use a random hue with fixed saturation and value.
	if (FRONT_FACING == false)
	{
		float hue_offset = texture(hue_noise_texture, pos_world.xyz).r;
		vec3 hsv = vec3(hue_offset, 0.85, 0.75);
		vec3 rgb = hsv2rgb(hsv);
		EMISSION = rgb;
		// Set albedo 0 so that it doesn't look affected by light for now
		ALBEDO = vec3(0);
		//ALPHA = surface_albedo.a;
	}
}