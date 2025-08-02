shader_type spatial;

uniform float fill_amount : hint_range(0.0, 1.0);
uniform vec4 color1 : source_color;
uniform vec4 color2 : source_color;

void fragment() {
    vec2 uv = UV * 2.0 - 1.0; // Center at (0,0)
    float dist = length(uv);

    // Discard pixels outside the circle
    if (dist > 1.0) {
        discard;
    }

    float angle = atan(uv.y, uv.x); // -PI to PI
    angle = (-angle) / (2.0 * 3.14159265); // Normalize to 0..1

    // Color switching
    //vec4 current_color = mix(color1, color2, step(0.5, mod(angle + fill_amount, 1.0)));
	vec4 current_color = color1;
    // Fill mask
    if (mod(angle, 1.0) > fill_amount) {
        current_color = color2;
		//current_color.a = 0.0; // Transparent if not yet filled
    }
	ALBEDO = current_color.xyz;
	ALPHA = current_color.a;
    //COLOR = current_color;
}
