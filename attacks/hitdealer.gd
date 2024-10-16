extends Area2D
class_name HitDealer


signal hit_landed(hitbox: HitBox, damage: float, hitbox_died: bool)

@export var damage: int = 10


func _ready() -> void:
	area_entered.connect(_on_area_entered)


func _on_area_entered(area: Area2D) -> void:
	if area is HitBox:
		hit_landed.emit(area as HitBox, damage, (area as HitBox).hit(self, damage))
