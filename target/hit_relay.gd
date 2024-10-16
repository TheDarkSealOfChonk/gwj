extends Node


@onready var hit_shaker: HitShaker = $"../Sprite/HitShaker"

var health = 20


func _on_target_hit_landed(hitbox: HitBox, _hitdealer: HitDealer, damage: int) -> void:
	#get_tree().create_timer(0.3).timeout.connect(hit_shaker.shake)
	hit_shaker.shake()
	health -= damage
	hitbox.dead = health <= 0
	if hitbox.dead:
		$"..".queue_free()
