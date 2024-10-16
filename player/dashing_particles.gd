extends GPUParticles2D


func update_from_velocity(velocity: Vector2):
	rotation = Vector2().angle_to_point(velocity) + PI
	process_material.gravity.x = velocity.length()


func start_dash():
	restart()
	visible = true


func stop_dash():
	visible = false
	emitting = false
