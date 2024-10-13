extends Node


@onready var hit_shaker: HitShaker = $"../Sprite/HitShaker"


func _on_target_hit_landed(damage: int) -> void:
	hit_shaker.shake()
