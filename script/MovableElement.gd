extends Node3D

var is_rotating: bool
var is_translating: bool
var last_mouse_position : Vector2
var general_settings: GeneralSettings

func _init():
	is_rotating = false
	is_translating = false
	general_settings = GeneralSettings.get_instance()
	
func _ready():
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	process_rotation(delta)
	process_translation(delta)

func _unhandled_input(event):
	if event is InputEventKey:
		if event.pressed && event.keycode == KEY_R:
			position = Vector3(0, 0, 0)
			rotation = Vector3(0, 0, 0)
				
			
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT:
			if event.pressed:
				is_rotating = true
				last_mouse_position = get_viewport().get_mouse_position()
			else:
				is_rotating = false
		
		if event.button_index == MOUSE_BUTTON_RIGHT:
			if event.pressed:
				is_translating = true
				last_mouse_position = get_viewport().get_mouse_position()
			else:
				is_translating = false
		
		if event.button_index == MOUSE_BUTTON_WHEEL_UP and event.pressed:
			global_translate(Vector3(0, 0, 1 * general_settings.zoom_factor))
			
		if event.button_index == MOUSE_BUTTON_WHEEL_DOWN and event.pressed:
			global_translate(Vector3(0, 0, -1 * general_settings.zoom_factor))

func process_rotation(delta):
	if is_rotating:
		var delta_pos = (get_viewport().get_mouse_position() - last_mouse_position) * delta * general_settings.rotate_factor
		rotation += Vector3(delta_pos.y, delta_pos.x, 0.0)
		last_mouse_position = get_viewport().get_mouse_position()

func process_translation(delta):
	if is_translating:
		var delta_pos = (get_viewport().get_mouse_position() - last_mouse_position) * delta * general_settings.translate_factor
		global_translate( Vector3(delta_pos.x, -delta_pos.y, 0) )
		last_mouse_position = get_viewport().get_mouse_position()
		
