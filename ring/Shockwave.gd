extends CanvasLayer
@onready var animation_player: AnimationPlayer = $AnimationPlayer

func spawn_shockwave():
	animation_player.play("spawn_shockwave")
