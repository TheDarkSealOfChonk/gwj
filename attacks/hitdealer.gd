extends Area2D
class_name HitDealer


@export var damage: int = 10


func _ready() -> void:
	area_entered.connect(_on_area_entered)


func _on_area_entered(area: Area2D) -> void:
	if area is HitBox:
		(area as HitBox).hit(damage)
