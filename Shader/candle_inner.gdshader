shader_type spatial;

const float HALF_PI = PI / 2.0;

uniform vec4 mesh_color;
uniform float diameter = 3.183;
uniform float height = 10.0;
uniform float base_height = 1.0;

bool is_bottom_vertex(vec3 vertex){
	return vertex.y <= base_height - (height / 2.0);
}

vec3 vertex_from_uv(vec2 uv, vec3 vertex){
	if( is_bottom_vertex(vertex) ){
		return vec3(0.0, base_height - (height / 2.0), 0.0);
	}
	
	float t = uv.x * TAU;
	float x = sin(t);
	float z = -cos(t);
	float radius = diameter / 2.0;
	
	return vec3(x * radius, vertex.y, z * radius);
}

vec3 compute_normal(vec2 uv, vec3 vertex){
	if( is_bottom_vertex(vertex) ){
		return normalize( vec3(
			0.0,
			1.0,
			0.0
		));
	}
	else
	{
		return normalize( vec3(
			-sin(uv.x * TAU),
			0.00,
			cos(uv.x * TAU)
		));
	}
}

void vertex() {
	VERTEX = vertex_from_uv(UV, VERTEX);
	NORMAL = compute_normal(UV, VERTEX);
}

void fragment(){
	ALBEDO = mesh_color.rgb;
}

