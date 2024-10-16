extends Node
class_name SettingsManager


const DEFAULT_SETTINGS = {
	"oink_mode_enabled": false,
	"high_score": 0,
}

var config_file: ConfigFile = ConfigFile.new()


func _ready() -> void:
	if !FileAccess.file_exists("user://settings.cfg"):
		default_settings()
	config_file.load("user://settings.cfg")


func default_settings():
	var file = ConfigFile.new()
	
	for setting_key in DEFAULT_SETTINGS.keys():
		file.set_value("section", setting_key, DEFAULT_SETTINGS[setting_key])
	
	file.save("user://settings.cfg")


func save_settings():
	config_file.save("user://settings.cfg")


func toggle_oink_mode():
	config_file.set_value("section", "oink_mode_enabled", !config_file.get_value("section", "oink_mode_enabled"))


func is_oink_mode_enabled() -> bool:
	return config_file.get_value("section", "oink_mode_enabled")
