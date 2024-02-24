class_name OverlayUI
extends Control

@onready var _overlay_text = %overlay_text
@onready var _progress_bar: ProgressBar = %ProgressBar
@onready var _text_progress = %text_progress

func _ready():
	show_progress(false)

func open_overlay(text):
	_overlay_text.text = text
	visible = true
	
func close_overlay():
	visible = false
	_overlay_text.text = "Please wait..."

func show_progress(is_show: bool):
	_progress_bar.visible = is_show
	
func set_max_progress(max_value: float):
	_progress_bar.max_value = max_value
	
func set_progress(value: float):
	_progress_bar.value = value
	_text_progress.text = "%d/%d" % [value, _progress_bar.max_value]
	
	
