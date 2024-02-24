shader_type spatial;

uniform vec4 mesh_color;

void fragment() {
	ALBEDO = mesh_color.rgb;
}
