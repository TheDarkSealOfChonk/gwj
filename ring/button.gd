extends Button
@onready var canvas_layer: CanvasLayer = $".."



func _on_pressed() -> void:
	canvas_layer.spawn_shockwave()
