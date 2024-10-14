extends Button


const RING = preload("res://ring/ring.tscn")


func _on_button_up() -> void:
	$"..".queue_free()
	$/root/Main.add_child(RING.instantiate())
