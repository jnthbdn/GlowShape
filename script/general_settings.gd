class_name GeneralSettings

const settings_file = "user://general_settings.cfg"

static var _instance : GeneralSettings

var config: ConfigFile
var rotate_factor : float = 1.0
var translate_factor : float = 2.0
var zoom_factor: float = 1.5
var object_color: Color = Color.WHITE

static func get_instance() -> GeneralSettings:
	if _instance == null:
		_instance = GeneralSettings.new()
		
	return _instance;

func _init():
	load_settings()

func save_settings():
	config.set_value("settings", "rotate_factor", rotate_factor)
	config.set_value("settings", "translate_factor", translate_factor)
	config.set_value("settings", "zoom_factor", zoom_factor)
	config.set_value("settings", "object_color", object_color)
	config.save(settings_file)
	
func load_settings():
	if config == null:
		config = ConfigFile.new()
	
	var err_open: Error = config.load(settings_file)
	
	match err_open:
		Error.OK:
			rotate_factor = config.get_value("settings", "rotate_factor")
			translate_factor = config.get_value("settings", "translate_factor")
			zoom_factor = config.get_value("settings", "zoom_factor")
			object_color = config.get_value("settings", "object_color")
			
		Error.ERR_FILE_NOT_FOUND:
			save_settings()
			
		_:
			printerr("Failed to load generic settings file (err code: %d)" % err_open)
		
	
