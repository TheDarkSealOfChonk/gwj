extends Area2D
class_name HitBox


signal hit_landed(damage: int)


func hit(damage: int):
	hit_landed.emit(damage)
