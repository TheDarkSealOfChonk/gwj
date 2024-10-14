extends Node
class_name OinkModeToggler


var next_letter_action = 0
var letter_actions = ["oink_mode_o", "oink_mode_i", "oink_mode_n", "oink_mode_k"]


func _process(delta: float) -> void:
	if Input.is_action_just_pressed(letter_actions[next_letter_action]):
		next_letter_action += 1
		if next_letter_action == 4:
			$/root/Main/SettingsManager.toggle_oink_mode()
			$/root/Main/SettingsManager.save_settings()
			next_letter_action = 0
