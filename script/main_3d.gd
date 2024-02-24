extends Node3D

const DEFAULT_BACK_SHADER = preload("res://Shader/default_back.gdshader")
const FLAT_SHADER = preload("res://Shader/flat.gdshader")
const CANDLE_SHADER = preload("res://Shader/candle.gdshader")
const CANDLE_BACK_SHADER = preload("res://Shader/candle_inner.gdshader")

@onready var mesh: MeshInstance3D = %mesh
@onready var back_mesh: MeshInstance3D = %back_mesh
@onready var mesh_shader : ShaderMaterial = mesh.get_active_material(0)
@onready var back_mesh_shader : ShaderMaterial = back_mesh.get_active_material(0)
@onready var movable_element = %MovableElement

var litho_image: LithoImage
var texture: ImageTexture
var current_mesh_type: BaseMesh.MeshType
var subdivsion_divider: float = 1.0

func _physics_process(_delta):
	mesh_shader.set_shader_parameter("mesh_color", GeneralSettings.get_instance().object_color)
	back_mesh_shader.set_shader_parameter("mesh_color", GeneralSettings.get_instance().object_color)

func set_shape(mesh_type: BaseMesh.MeshType):
	current_mesh_type = mesh_type
	
	match mesh_type:
		BaseMesh.MeshType.CANDLE_HOLDER:
			mesh_shader.shader = CANDLE_SHADER
			back_mesh_shader.shader = CANDLE_BACK_SHADER
			_set_subdivision_back_mesh(litho_image.image.get_width(), litho_image.image.get_height())
		
		BaseMesh.MeshType.FLAT, _:
			mesh_shader.shader = FLAT_SHADER
			back_mesh_shader.shader = DEFAULT_BACK_SHADER
			_set_subdivision_back_mesh(0, 0)

func set_show_image(is_show: bool):
	mesh_shader.set_shader_parameter("is_image_show", is_show)
	
func load_image(img: Image):
	litho_image = LithoImage.new(img)
	texture = ImageTexture.create_from_image(litho_image.image)
	mesh_shader.set_shader_parameter("image", texture)
	
	set_subdivision_divider(subdivsion_divider)
	
func set_size(width: float, height: float):
	(mesh.mesh as QuadMesh).size = Vector2(width, height)
	(back_mesh.mesh as QuadMesh).size = Vector2(width, height)
	
	if current_mesh_type == BaseMesh.MeshType.CANDLE_HOLDER :
		mesh_shader.set_shader_parameter("diameter", width / PI)
		back_mesh_shader.set_shader_parameter("diameter", width / PI)
		back_mesh_shader.set_shader_parameter("height", height)
		
	movable_element.scale = Vector3.ONE / (max(width, height) / 10.0)

func set_candle_holder_base_height(height):
	back_mesh_shader.set_shader_parameter("base_height", height)

func set_invert_value(is_invert: bool):
	mesh_shader.set_shader_parameter("is_invert", is_invert)

func set_flip_x(is_flip: bool):
	litho_image.set_flip_x(is_flip)
	_update_shader()
	
func set_flip_y(is_flip: bool):
	litho_image.set_flip_y(is_flip)
	_update_shader()
	
func set_image_rotation(angle: int):
	litho_image.set_rotation(angle)
	_update_shader()

func set_thickness(min_thickness: float, max_thickness: float):
	mesh_shader.set_shader_parameter("min_z", min_thickness)
	mesh_shader.set_shader_parameter("max_z", max_thickness)
	

func set_subdivision_divider(divider: float):
	subdivsion_divider = divider;
	
	(mesh.mesh as QuadMesh).subdivide_width = int(litho_image.image.get_width() / subdivsion_divider)
	(mesh.mesh as QuadMesh).subdivide_depth = int(litho_image.image.get_height() / subdivsion_divider)
	mesh_shader.set_shader_parameter("width_division", litho_image.image.get_width() / subdivsion_divider)
	mesh_shader.set_shader_parameter("height_division", litho_image.image.get_height() / subdivsion_divider)

func get_subdivision_width() -> float:
	return (mesh.mesh as QuadMesh).subdivide_width	

func get_subdivision_height() -> float:
	return (mesh.mesh as QuadMesh).subdivide_depth

func _update_shader():
	texture.update(litho_image.image)
	
func _set_subdivision_back_mesh(sub_width: int, sub_height: int):
	(back_mesh.mesh as QuadMesh).subdivide_width = sub_width
	(back_mesh.mesh as QuadMesh).subdivide_depth = sub_height

