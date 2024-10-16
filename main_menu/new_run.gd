extends TextureButton


const RING = preload("res://ring/ring.tscn")


func _on_button_up() -> void:
	get_tree().create_timer(0.2).timeout.connect(func(): 	$"..".queue_free(); $/root/Main.add_child(RING.instantiate()))
