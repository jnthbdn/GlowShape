shader_type spatial;

uniform vec4 mesh_color;
uniform sampler2D image : source_color;
uniform bool is_image_show = false;
uniform bool is_invert = false;

uniform float width_division = 100.0;
uniform float height_division = 100.0;
uniform float min_z = 0.0;
uniform float max_z = 1.0;

varying vec3 norm;

float get_height(vec2 uv){
	vec4 color = texture(image, uv);
	float gray = 0.2126 * color.r + 0.7152 * color.g + 0.0722 * color.b;
	float h = gray * (max_z - min_z) + min_z;
	
	return is_invert ? h : ((max_z + min_z) - h);
}

bool is_border(vec2 uv_pos){
	return uv_pos.x <= 0.0001 || uv_pos.x >= 1.0 || uv_pos.y <= 0.0001 || uv_pos.y >= 1.0;
}

vec3 compute_normal(vec3 vertex, vec2 uv){
	float uv_w_step = 1.0 / width_division;
	float uv_h_step = 1.0 / height_division;
	
	float p1 = get_height(uv + vec2(-uv_w_step, 0.0));
	float p2 = get_height(uv + vec2(uv_w_step, 0.0));
	float p3 = get_height(uv + vec2(0.0, -uv_h_step));
	float p4 = get_height(uv + vec2(0.0, uv_h_step));
	
	vec3 normal = vec3(
		p2 - p1,
		p4 - p3,
		2.0
	);
	
	return normalize(normal);
}

void vertex() {
	if( !is_border(UV) ){
		float h_value = get_height(UV);
		
		VERTEX.z = h_value;
	
		NORMAL = compute_normal(VERTEX, UV);
		norm = NORMAL;
	}
}

void fragment() {
	if( is_image_show )
		ALBEDO = texture(image, UV).rgb;
	else
		ALBEDO = mesh_color.rgb;
}

