extends Node


@onready var hit_shaker: HitShaker = $"../Sprite/HitShaker"


func _on_hit_box_hit_landed(_damage: int) -> void:
	hit_shaker.shake()
