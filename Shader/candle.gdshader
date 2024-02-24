shader_type spatial;

const float HALF_PI = PI / 2.0;

uniform vec4 mesh_color;
uniform sampler2D image : source_color;
uniform bool is_image_show = false;
uniform bool is_invert = false;

uniform float width_division = 100.0;
uniform float height_division = 100.0;
uniform float min_z = 0.0;
uniform float max_z = 1.0;
uniform float diameter = 10.0;


bool is_border(vec2 uv_pos){
	return (uv_pos.y <= 0.0001 || uv_pos.y >= 1.0);
}

bool is_bottom_vertex(vec2 uv_pos){
	return (uv_pos.y >= 1.0);
}

float get_height(vec2 uv){
	if( is_border(uv) ){
		return 0.0;
	}
	
	vec4 color = texture(image, uv);
	float gray = 0.2126 * color.r + 0.7152 * color.g + 0.0722 * color.b;
	float h = gray * (max_z - min_z) + min_z;
	
	return is_invert ? h : ((max_z + min_z) - h);
}

vec3 vertex_from_uv(vec2 uv, vec3 vertex){
	if( is_bottom_vertex(uv) ){
		return vec3(0.0, vertex.y, 0.0);
	}
	
	float height = get_height(uv);
	float t = uv.x * TAU;
	float x = -sin(t);
	float z = -cos(t);
	float radius = diameter / 2.0;
	
	
	return vec3(x * (radius + height), vertex.y, z * (radius + height));
}

vec3 compute_normal(vec3 vertex, vec2 uv){
	float uv_w_step = 1.0 / width_division;
	float uv_h_step = 1.0 / height_division;
	
	float p1 = get_height(uv + vec2(-uv_w_step, 0.0));
	float p2 = get_height(uv + vec2(uv_w_step, 0.0));
	float p3 = get_height(uv + vec2(0.0, -uv_h_step));
	float p4 = get_height(uv + vec2(0.0, uv_h_step));
	
	vec3 normal = vec3(
		sin(uv.x * TAU + PI) - (p2 - p1),
		p4 - p3,
		2.0 * cos(uv.x * TAU + PI)
	);
	
	return normalize(normal);
}

void vertex() {
	VERTEX = vertex_from_uv(UV, VERTEX);
	NORMAL = compute_normal(VERTEX, UV);
}

void fragment() {
	if( is_image_show )
		ALBEDO = texture(image, UV).rgb;
	else
		ALBEDO = mesh_color.rgb;
}

