extends AudioStreamPlayer


func _on_hit_dealer_hit_landed(hitbox: HitBox, damage: float, hitbox_died: bool) -> void:
	if hitbox_died:
		#get_tree().create_timer(0.2).timeout.connect(play)
		play()
