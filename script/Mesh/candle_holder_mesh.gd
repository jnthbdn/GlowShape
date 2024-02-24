class_name CandleHolderMesh extends BaseMesh

const remove_xz = Vector3(0.0, 1.0, 0.0)

var radius: float;
var base_height: float = 1.0;

func _init(nb_point_width, nb_point_height, min_thickness:float = 1.0, max_thickness:float = 2.0, invert_value: bool = false):
	super(nb_point_width, nb_point_height, min_thickness, max_thickness, invert_value)
	resize(self.width, self.height)

func resize(width: float, height: float):
	self.width = width
	self.height = height
	self.radius = (width / PI) / 2
	
func set_base_height(height: float):
	base_height = height

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
	var y_factor = height / nb_point_height
	var x_percent = 1.0 / nb_point_width;
	var nb_faces = (nb_point_width) * (nb_point_height-1)
	var buffer_vertex: PackedByteArray = PackedByteArray()
	var final_height = (nb_point_height - 1) * y_factor

	file.big_endian = false
	buffer_vertex.resize(100) # 3*4 normal + 3*4 p1 + 3*4 p2 + 3*4 p3 + 2 attribut = 50 bytes (*2)	
	progress_notifier.is_done = false
	progress_notifier.total_progress = nb_faces*2
	progress_notifier.current_progress = 0

	for _i in range(80):
		file.store_8(0)
	file.store_32(nb_faces*2 + nb_point_width*3)

	# OUTER PART
	for x in range(nb_point_width):
		for y in range(nb_point_height - 1):
			var pos_y = y * y_factor
			
			var sin_x = -sin(x * x_percent * TAU)
			var sin_x1 = -sin((x + 1) * x_percent * TAU)
			var cos_z = -cos(x * x_percent * TAU)
			var cos_z1 = -cos((x + 1) * x_percent * TAU)
			
			var p1 = Vector3(value_from_coord(x, y) * sin_x, pos_y,  value_from_coord(x, y) * cos_z)
			var p2 = Vector3(value_from_coord(x, y+1) * sin_x, pos_y + y_factor,  value_from_coord(x, y+1) * cos_z)
			var p3 = Vector3(value_from_coord(x+1, y+1) * sin_x1, pos_y + y_factor,  value_from_coord(x+1, y+1) * cos_z1)
			var normal = _normal_face(p1, p2, p3)
			
			_add_to_buffer_vector(buffer_vertex, 0, normal)
			_add_to_buffer_vector(buffer_vertex, 12, p1)
			_add_to_buffer_vector(buffer_vertex, 24, p2)
			_add_to_buffer_vector(buffer_vertex, 36, p3)
			buffer_vertex.encode_u16(48, 0)
			
			p2 = p3
			p3 = Vector3(value_from_coord(x+1, y) * sin_x1, pos_y, value_from_coord(x+1, y) * cos_z1)
			normal = _normal_face(p1, p2, p3)
			
			_add_to_buffer_vector(buffer_vertex, 50, normal)
			_add_to_buffer_vector(buffer_vertex, 62, p1)
			_add_to_buffer_vector(buffer_vertex, 74, p2)
			_add_to_buffer_vector(buffer_vertex, 86, p3)
			buffer_vertex.encode_u16(98, 0)
			file.store_buffer(buffer_vertex)
			
			progress_notifier.current_progress = x * (nb_point_height - 1) + y
			
	# INNER PART
	for x in range(nb_point_width):
		var sin_x = sin(x * x_percent * TAU)
		var sin_x1 = sin((x + 1) * x_percent * TAU)
		var cos_z = -cos(x * x_percent * TAU)
		var cos_z1 = -cos((x + 1) * x_percent * TAU)
		
		var p1 = Vector3(radius * sin_x, 	final_height,  		radius * cos_z)
		var p2 = Vector3(radius * sin_x1,	final_height,  		radius * cos_z1)
		var p3 = Vector3(radius * sin_x, 	base_height,  	radius * cos_z)
		var normal = _normal_face(p1, p2, p3)
		
		_add_to_buffer_vector(buffer_vertex, 0, normal)
		_add_to_buffer_vector(buffer_vertex, 12, p1)
		_add_to_buffer_vector(buffer_vertex, 24, p2)
		_add_to_buffer_vector(buffer_vertex, 36, p3)
		buffer_vertex.encode_u16(48, 0)
		
		p1 = Vector3(radius * sin_x1,	final_height,  		radius * cos_z1)
		p2 = Vector3(radius * sin_x1,	base_height,  	radius * cos_z1)
		p3 = Vector3(radius * sin_x, 	base_height,  	radius * cos_z)
		normal = _normal_face(p1, p2, p3)
		
		_add_to_buffer_vector(buffer_vertex, 50, normal)
		_add_to_buffer_vector(buffer_vertex, 62, p1)
		_add_to_buffer_vector(buffer_vertex, 74, p2)
		_add_to_buffer_vector(buffer_vertex, 86, p3)
		buffer_vertex.encode_u16(98, 0)
		file.store_buffer(buffer_vertex)
		
		progress_notifier.current_progress = nb_faces + x
			
			
	buffer_vertex.resize(50) # 3*4 normal + 3*4 p1 + 3*4 p2 + 3*4 p3 + 2 attribut = 50 bytes	
	# INNER END PART
	for x in range(nb_point_width):
		var sin_x = sin(x * x_percent * TAU)
		var sin_x1 = sin((x + 1) * x_percent * TAU)
		var cos_z = -cos(x * x_percent * TAU)
		var cos_z1 = -cos((x + 1) * x_percent * TAU)
		
		var p1 = Vector3(radius * sin_x, 	base_height,  	radius * cos_z)
		var p2 = Vector3(radius * sin_x1, 	base_height,  	radius * cos_z1)
		var p3 = Vector3(0, 				base_height,  	0)
		
		_add_to_buffer_vector(buffer_vertex, 0, Vector3(0, 1, 0))
		_add_to_buffer_vector(buffer_vertex, 12, p1)
		_add_to_buffer_vector(buffer_vertex, 24, p2)
		_add_to_buffer_vector(buffer_vertex, 36, p3)
		buffer_vertex.encode_u16(48, 0)
		file.store_buffer(buffer_vertex)
		
		progress_notifier.current_progress = nb_faces + nb_point_width + x
					
	## BOTTOM END PART
	for x in range(nb_point_width):
		var sin_x = sin(x * x_percent * TAU)
		var sin_x1 = sin((x + 1) * x_percent * TAU)
		var cos_z = -cos(x * x_percent * TAU)
		var cos_z1 = -cos((x + 1) * x_percent * TAU)
		
		var p1 = Vector3(radius * sin_x, 	0,  	radius * cos_z)
		var p2 = Vector3(radius * sin_x1, 	0,  	radius * cos_z1)
		var p3 = Vector3(0, 				0,  	0)
		
		_add_to_buffer_vector(buffer_vertex, 0, Vector3(0, 1, 0))
		_add_to_buffer_vector(buffer_vertex, 12, p1)
		_add_to_buffer_vector(buffer_vertex, 24, p2)
		_add_to_buffer_vector(buffer_vertex, 36, p3)
		buffer_vertex.encode_u16(48, 0)
		file.store_buffer(buffer_vertex)
		
		progress_notifier.current_progress = nb_faces + nb_point_width*2 + x
			
	progress_notifier.is_done = true


func value_from_coord(x, y) -> float:	
	if y == 0 || y == nb_point_height-1 :
		return radius
		
	if( x >= nb_point_width ):
		x -= nb_point_width
	
	return radius + z_values[ coord_to_index(x, y) ]
