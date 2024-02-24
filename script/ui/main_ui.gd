class_name MainUI
extends Control

@onready var _lithophane_ui = %LithophaneUI
@onready var _preference_ui = %PreferenceUI
@onready var main_3d = %Main3D
@onready var overlay = %Overlay

var export_worker: MeshWorker

func _ready():
	export_worker = MeshWorker.new(overlay)
	get_tree().root.add_child.call_deferred(export_worker)
	_lithophane_ui._load_image(load("res://default_litho.png"), "Godot <3")

func _on_tab_bar_tab_changed(tab: int):
	match tab:
		0:
			_lithophane_ui.visible = true
			_preference_ui.visible = false	
		
		1:
			_lithophane_ui.visible = false
			_preference_ui.visible = true
			

func _on_lithophane_ui_shape_changed(type: BaseMesh.MeshType):
	main_3d.set_shape(type)
	

func _on_lithophane_ui_image_changed(image: Image):
	main_3d.load_image(image)


func _on_lithophane_ui_show_image_changed(is_show):
	main_3d.set_show_image(is_show)
	
	
func _on_lithophane_ui_image_color_changed(is_negative):
	main_3d.set_invert_value(is_negative)


func _on_lithophane_ui_image_flip_x_changed(is_flip):
	main_3d.set_flip_x(is_flip)


func _on_lithophane_ui_image_flip_y_changed(is_flip):
	main_3d.set_flip_y(is_flip)


func _on_lithophane_ui_image_rotation_changed(angle):
	main_3d.set_image_rotation(angle)
	

func _on_lithophane_ui_image_resolution_changed(resolution):
	main_3d.set_subdivision_divider(resolution)


func _on_lithophane_ui_lithophane_thickness_changed(min_value, max_value):
	main_3d.set_thickness(min_value, max_value)


func _on_lithophane_ui_plate_size_changed(width, height):
	main_3d.set_size(width, height)


func _on_lithophane_ui_candle_size_changed(height, diameter):
	main_3d.set_size(diameter * PI, height)
	
func _on_lithophane_ui_candle_base_height_changed(height):
	main_3d.set_candle_holder_base_height(height)


func _on_lithophane_ui_export_file_selected(_export_type, file_path):
	var image = main_3d.litho_image
	var mesh : BaseMesh;
	
	var points_width = main_3d.get_subdivision_width()
	var points_height = main_3d.get_subdivision_height()
	
	
	match _lithophane_ui.get_selected_meshtype():
		BaseMesh.MeshType.FLAT:
			mesh = FlatMesh.new(points_width, points_height, _lithophane_ui.get_min_thickness(), _lithophane_ui.get_max_thickness(), _lithophane_ui.is_color_inverted())
			
		BaseMesh.MeshType.CANDLE_HOLDER:
			mesh = CandleHolderMesh.new(points_width, points_height, _lithophane_ui.get_min_thickness(), _lithophane_ui.get_max_thickness(), _lithophane_ui.is_color_inverted())
		
		_:
			printerr("Incorrect selected shape...")
			return
	
	mesh.resize(_lithophane_ui.get_width_shape(), _lithophane_ui.get_height_shape())
	export_worker.save_as_stl(mesh, file_path, image)

func _on_lithophane_ui_load_file_dioalog_opened():
	overlay.show_progress(false)
	overlay.open_overlay("Please select a file...\n(The dialog box may take a few seconds to open)")


func _on_lithophane_ui_save_file_dialog_opened():
	overlay.show_progress(false)
	overlay.open_overlay("Please choose an export location...\n(The dialog box may take a few seconds to open)")


func _on_lithophane_ui_load_file_dialog_closed():
	overlay.close_overlay()


func _on_lithophane_ui_save_file_dialog_closed():
	overlay.close_overlay()
