class_name FlatMesh extends BaseMesh

func _init(nb_point_width, nb_point_height, min_thickness:float = 1.0, max_thickness:float = 2.0, invert_value: bool = false):
	super(nb_point_width, nb_point_height, min_thickness, max_thickness, invert_value)
	
func compute_mesh(data: LithoImage, progress_notifier: ProgressionNotifier):
	progress_notifier.is_done = false
	progress_notifier.total_progress = nb_point_width * nb_point_height
	progress_notifier.current_progress = 0
	
	data.flip_y()
	
	var x_step = data.image.get_width() / nb_point_width
	var y_step = data.image.get_height() / nb_point_height
	
	for x in nb_point_width:
		for y in nb_point_height:
			var grey = data.get_pixel_value(x * x_step, y * y_step, is_invert_values)
			z_values[coord_to_index(x, y)] = min_value + (grey * (max_value - min_value))
			progress_notifier.current_progress = x * nb_point_height + y
	
	progress_notifier.is_done = true
	
	data.flip_y()

func to_stl(file_path: String, progress_notifier: ProgressionNotifier):
	var file = FileAccess.open(file_path, FileAccess.WRITE)
	var x_factor = width / nb_point_width
	var y_factor = height / nb_point_height
	var nb_faces = (nb_point_width-1) * (nb_point_height-1)
	var buffer_vertex: PackedByteArray = PackedByteArray()

	file.big_endian = false
	buffer_vertex.resize(100) # 3*4 normal + 3*4 p1 + 3*4 p2 + 3*4 p3 + 2 attribut = 50 bytes (*2)	
	progress_notifier.is_done = false
	progress_notifier.total_progress = nb_faces
	progress_notifier.current_progress = 0

	for _i in range(80):
		file.store_8(0)
	file.store_32(nb_faces*2 + 2)
	
	var b_width = (nb_point_width-1) * x_factor
	var b_height = (nb_point_height-1) * y_factor
	
	_add_to_buffer_vector(buffer_vertex, 0, Vector3(0, 0, -1))
	_add_to_buffer_vector(buffer_vertex, 12, Vector3(0, 0, 0))
	_add_to_buffer_vector(buffer_vertex, 24, Vector3(b_width, b_height, 0))
	_add_to_buffer_vector(buffer_vertex, 36, Vector3(0, b_height, 0))
	buffer_vertex.encode_u16(48, 0)
	
	_add_to_buffer_vector(buffer_vertex, 50, Vector3(0, 0, -1))
	_add_to_buffer_vector(buffer_vertex, 62, Vector3(0, 0, 0))
	_add_to_buffer_vector(buffer_vertex, 74, Vector3(b_width, 0, 0))
	_add_to_buffer_vector(buffer_vertex, 86, Vector3(b_width, b_height, 0))
	buffer_vertex.encode_u16(98, 0)
	file.store_buffer(buffer_vertex)

	
	for x in range(nb_point_width - 1):
		var pos_x = x * x_factor
		
		for y in range(nb_point_height - 1):
			var pos_y = y * y_factor
			
			var p1 = Vector3( pos_x, 			pos_y, 				value_from_coord(x, y) )
			var p2 = Vector3( pos_x, 			pos_y + y_factor, 	value_from_coord(x, y+1) )
			var p3 = Vector3( pos_x + x_factor, pos_y + y_factor, 	value_from_coord(x+1, y+1) )
			var normal = _normal_face(p1, p2, p3)
			
			_add_to_buffer_vector(buffer_vertex, 0, normal)
			_add_to_buffer_vector(buffer_vertex, 12, p1)
			_add_to_buffer_vector(buffer_vertex, 24, p2)
			_add_to_buffer_vector(buffer_vertex, 36, p3)
			buffer_vertex.encode_u16(48, 0)
			
			p2 = p3
			p3 = Vector3( pos_x + x_factor, pos_y, value_from_coord(x+1, y))
			normal = _normal_face(p1, p2, p3)
			
			_add_to_buffer_vector(buffer_vertex, 50, normal)
			_add_to_buffer_vector(buffer_vertex, 62, p1)
			_add_to_buffer_vector(buffer_vertex, 74, p2)
			_add_to_buffer_vector(buffer_vertex, 86, p3)
			buffer_vertex.encode_u16(98, 0)
			file.store_buffer(buffer_vertex)
			
			progress_notifier.current_progress = x * (nb_point_height - 1) + y
		
	progress_notifier.is_done = true

func value_from_coord(x, y) -> float:	
	if( x == 0 || y == 0 || x == nb_point_width-1 || y == nb_point_height-1 ):
		return 0.0
	
	return z_values[ coord_to_index(x, y) ]

