extends Control

var general_settings : GeneralSettings

@onready var rotate_factor = %rotate_factor
@onready var translate_factor = %translate_factor
@onready var zoom_factor = %zoom_factor
@onready var object_color = %object_color


func _ready():
	general_settings = GeneralSettings.get_instance()
	rotate_factor.value = general_settings.rotate_factor
	translate_factor.value = general_settings.translate_factor
	zoom_factor.value = general_settings.zoom_factor
	object_color.color = general_settings.object_color

func _on_rotate_factor_value_changed(value):
	general_settings.rotate_factor = value
	general_settings.save_settings()

func _on_translate_factor_value_changed(value):
	general_settings.translate_factor = value
	general_settings.save_settings()
	
func _on_zoom_factor_value_changed(value):
	general_settings.zoom_factor = value
	general_settings.save_settings()
	
func _on_object_color_value_changed(color):
	general_settings.object_color = color
	general_settings.save_settings()
