extends AnimatedSprite2D


var direction = 0
var walking = false


func update_direction_from_rad(angle: float):
	angle = wrapf(angle, 0.0, TAU)
	var value = int((angle / TAU) * 4)
	update_direction(value)


func update_direction(value: int):
	direction = value


func update_walking(value: bool):
	walking = value


func flush_to_animation():
	if direction == 0:
		flip_h = true
		if walking:
			animation = "move_lr"
		else:
			animation = "idle_lr"
	elif direction == 1:
		flip_h = false
		if walking:
			animation = "move_d"
		else:
			animation = "idle_d"
	elif direction == 2:
		flip_h = false
		if walking:
			animation = "move_lr"
		else:
			animation = "idle_lr"
	elif direction == 3:
		flip_h = false
		if walking:
			animation = "move_u"
		else:
			animation = "idle_u"
