class_name LithophaneUI
extends Control

########## SIGNALS ##########
signal load_file_dioalog_opened()
signal load_file_dialog_closed()
signal save_file_dialog_opened()
signal save_file_dialog_closed()

# ===== General Settings =====
signal show_image_changed(is_show: bool)
signal shape_changed(type: BaseMesh.MeshType)

# ===== Image settings =====
signal image_changed(image: Image)
signal image_color_changed(is_negative: bool)
signal image_flip_x_changed(is_flip: bool)
signal image_flip_y_changed(is_flip: bool)
signal image_rotation_changed(angle: int)
signal image_resolution_changed(resolution: float)

# ===== Shape settings =====
# --- Plate
signal plate_size_changed(width: float, height: float)

# --- Candle Holder
signal candle_size_changed(height: float, diameter: float)
signal candle_base_height_changed(height: float)

# ===== Lithophane settings =====
signal lithophane_thickness_changed(min: float, max: float)

# ===== export =====
signal export_file_selected(type: ExportType, file_path: String)

########## UI VARIABLE ##########
#FileDialog
@onready var _open_file_image = %OpenFileImage
@onready var _export_file = %ExportFile

@onready var _label_filename = %LabelFilename
@onready var _text_image_width = %image_width
@onready var _text_image_height = %image_height
@onready var _select_shape = %SelectShape

@onready var _ui_group_to_disable = [%image_settings_container, %shape_settings, %lithophane_settings_container, %HBoxContainer]

@onready var _ui_is_color_inverse = %inverse


# Plate settings
@onready var _plate_width = %plateWidth
@onready var _plate_height = %plateHeight

# Candle holder settings
@onready var _candle_height = %candle_height
@onready var _candle_diameter = %candle_diameter
@onready var _candle_base_height = %candle_base_height

# Lithophane settings
@onready var _min_thickness = %minThickness
@onready var _max_thickness = %maxThickness

enum ExportType {
	STL = 0,
	STEP = 1
}

var _current_shape: BaseMesh.MeshType
var _export_type: ExportType
var _image_ratio: float = 1.0

func _ready():
	set_visible_settings_sections(false)
	_open_file_image.set_filters(PackedStringArray(["*.png, *.jpg, *.jpeg, *.bmp, *.tga ; Supported images files (*.png, *.jpg, *.jpeg, *.bmp, *.tga)", "*.png ; PNG files", "*.jpg, *.jpeg; JPEG files","*.bmp ; BMP files", "*.tga ; TGA files"]))
	_export_file.set_filters(PackedStringArray(["*.STL ; STL file (.stl)", "*.step ; STEP file (.stp, .step)"]))


#region File Settings
func _on_load_file_button_pressed():
	_text_image_height.text = "N/A"
	_text_image_width.text = "N/A"
	_open_file_image.popup();
	load_file_dioalog_opened.emit()

func _on_open_file_image_file_selected(path: String):
	var image = Image.load_from_file(path)
	load_file_dialog_closed.emit()
	_load_image(image, path.get_file())

func _on_file_dialog_cancel():
	load_file_dialog_closed.emit()
	save_file_dialog_closed.emit()
	
func _on_check_show_image_toggled(toggled_on):
	show_image_changed.emit(toggled_on)

func _on_select_shape_item_selected(index):
	_hide_all_shape_settings()
	
	match _shape_index_to_meshtype(index):
		BaseMesh.MeshType.FLAT:
			%plate_settings_container.visible = true
			_current_shape = BaseMesh.MeshType.FLAT
			shape_changed.emit(BaseMesh.MeshType.FLAT)
			_on_plate_size_height_changed(_plate_height.value)
		
		BaseMesh.MeshType.CANDLE_HOLDER:
			%candle_settings_contrainer.visible = true
			_current_shape = BaseMesh.MeshType.CANDLE_HOLDER
			shape_changed.emit(BaseMesh.MeshType.CANDLE_HOLDER)
			_on_candle_height_changed(_candle_height.value)
			
		_:
			print("UNKNOWN")
#endregion

#region Image settings
func _on_color_settings_changed(is_negative:bool):
	image_color_changed.emit(is_negative)
	
func _on_flip_x_settings_changed(is_flip: bool):
	image_flip_x_changed.emit(is_flip)
	
func _on_flip_y_settings_changed(is_flip: bool):
	image_flip_y_changed.emit(is_flip)
	
func _on_rotate_settings_changed(angle: int):
	image_rotation_changed.emit(angle)
	
func _on_image_settings_resolution(resolution: float):
	image_resolution_changed.emit(resolution)
#endregion
	
#region Flat Settings 
func _on_plate_size_width_changed(width: float):
	_plate_height.set_value_no_signal(width / _image_ratio)
	plate_size_changed.emit(width, _plate_height.value)
	
func _on_plate_size_height_changed(height: float):
	_plate_width.set_value_no_signal(height * _image_ratio)
	plate_size_changed.emit(_plate_width.value, height)
#endregion

#region Candle Holder Settings
func _on_candle_height_changed(height: float):
	var width = height * _image_ratio
	_candle_diameter.set_value_no_signal(width / PI)
	candle_size_changed.emit(height, _candle_diameter.value)
	
func _on_candle_diameter_changed(diameter: float):
	var width = diameter * PI
	_candle_height.set_value_no_signal(width / _image_ratio)
	candle_size_changed.emit(_candle_height.value, diameter)
	
func _on_candle_base_height_changed(height: float):
	if( height > _candle_height.value ):
		height = _candle_height.value
		_candle_base_height.value = _candle_height.value
	
	candle_base_height_changed.emit(height)
#endregion
	
#region Lithophane Settings
func _on_lithophane_thickness_changed(_value):
	if( _min_thickness.value >= _max_thickness.value):
		_max_thickness.value = _min_thickness.value
		
	lithophane_thickness_changed.emit(_min_thickness.value, _max_thickness.value)
#endregion
	
#region Export
func _on_export_file_file_selected(path):
	print("Save file [" + str(_export_type) + "]: " + path)
	save_file_dialog_closed.emit()
	
	if path.get_extension() == "":
		path += ".stl"
		
	export_file_selected.emit(_export_type, path)
	
func _on_export_button_pressed(type: String):
	_export_file.current_file = _label_filename.text.get_basename()
	
	match type.to_upper():
		"STL":
			_export_type = ExportType.STL
			_export_file.current_file += ".stl"
			_export_file.set_filters(PackedStringArray(["*.stl ; STL filess (.stl)"]))
		
		"STEP":
			_export_type = ExportType.STEP
			_export_file.current_file += ".step"
			_export_file.set_filters(PackedStringArray(["*.step ; STEP files (.stp, .step)"]))
			
		_:
			printerr("Unknown export type")
			return
			
	save_file_dialog_opened.emit()
	_export_file.popup()	
#endregion

func _hide_all_shape_settings():
	for child in %shape_settings.get_children():
		child.visible = false
	
func _load_image(image: Image, filename: String):
	_label_filename.text = filename
	_label_filename.tooltip_text = filename
	
	_image_ratio = float(image.get_width()) / float(image.get_height())
	_plate_height.set_value_no_signal(_plate_width.value / _image_ratio)
	
	_text_image_width.text = str(image.get_width()) + " px"
	_text_image_height.text = str(image.get_height()) + " px"
	
	set_visible_settings_sections(true)
	plate_size_changed.emit(_plate_width.value, _plate_height.value)
	image_changed.emit(image)	

func _shape_index_to_meshtype(index: int) -> BaseMesh.MeshType:
	
	match index:
		0: # Flat
			return BaseMesh.MeshType.FLAT
		
		1: #Candle Holder
			return BaseMesh.MeshType.CANDLE_HOLDER
			
		_:
			return BaseMesh.MeshType.FLAT
			
func set_visible_settings_sections(is_disable: bool):
	for parent in _ui_group_to_disable:
		parent.visible = is_disable
		
func get_plate_width() -> float: 
	return _plate_width.value
	
func get_plate_height() -> float:
	return _plate_width.value

func get_min_thickness() -> float:
	return _min_thickness.value
	
func get_max_thickness() -> float:
	return _max_thickness.value
	
func is_color_inverted() -> bool:
	return _ui_is_color_inverse.button_pressed

func get_selected_meshtype() -> BaseMesh.MeshType:
	return _shape_index_to_meshtype( _select_shape.selected )
	
func get_width_shape() -> float:
	match _current_shape:
		BaseMesh.MeshType.FLAT:
			return _plate_width.value
			
		BaseMesh.MeshType.CANDLE_HOLDER:
			return _candle_diameter.value * PI
		
		_:
			printerr("Unknown shape...")
			return 0
	
func get_height_shape() -> float:
	match _current_shape:
		BaseMesh.MeshType.FLAT:
			return _plate_height.value
			
		BaseMesh.MeshType.CANDLE_HOLDER:
			return _candle_height.value
		
		_:
			printerr("Unknown shape...")
			return 0
