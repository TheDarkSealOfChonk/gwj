extends Area2D
class_name HitBox


signal hit_landed(hitbox: HitBox, hitdealer: HitDealer, damage: int)

var dead = false


func hit(hitdealer: HitDealer, damage: int) -> bool:
	hit_landed.emit(self, hitdealer, damage)
	return dead


func kill():
	dead = true
