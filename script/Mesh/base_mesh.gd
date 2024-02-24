class_name BaseMesh

var nb_point_width: int
var nb_point_height: int
var width: float
var height: float
var min_value: float
var max_value: float
var is_invert_values: bool
var z_values: Array

enum MeshType {
	FLAT,
	CANDLE_HOLDER,
	#CYLINDER,
	INNER_ARC,
	OUTER_ARC,
}

func _init(nb_point_width, nb_point_height, min_thickness:float = 1.0, max_thickness:float = 2.0, invert_value: bool = false):
	self.nb_point_width = nb_point_width
	self.nb_point_height = nb_point_height
	width = nb_point_width
	height = nb_point_height
	min_value = min_thickness
	max_value = max_thickness
	is_invert_values = invert_value
	z_values.resize(nb_point_width*nb_point_height)

func set_min_thickness(thickness):
	if thickness <= 0:
		return
		
	min_value = thickness
	
func set_max_thickness(thickness):
	if thickness <= 0:
		return
		
	max_value = thickness

func resize(width: float, height: float):
	self.width = width
	self.height = height

func compute_mesh(_data: LithoImage, _progress_notifier: ProgressionNotifier):
	assert(false, "'compute_mesh' not implemented !")

func to_stl(_file_path: String, _progress_notifier: ProgressionNotifier):
	assert(false, "'to_stl' not implemented !")
	
func to_mesh_data() -> Array:
	assert(false, "'to_mesh_data' not implemented !")
	return []
	

func coord_to_index(x, y) -> int:
	return y * nb_point_width + x;

func _normal_face(p1: Vector3, p2: Vector3, p3: Vector3) -> Vector3:
	var U = p2 - p1
	var V = p3 - p1

	return Vector3(
		(U.y * V.z) + (U.z * V.y),
		(U.z * V.x) + (U.x * V.z),
		(U.x * V.y) + (U.y * V.x)
	)

func _add_to_buffer_vector(buffer: PackedByteArray, start: int, v: Vector3):
	buffer.encode_float(start, v.x)
	buffer.encode_float(start+4, v.y)
	buffer.encode_float(start+8, v.z)
