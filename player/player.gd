extends RigidBody2D


const SPEED = 3000.0
const ATTACK_MINIDASH_SPEED = 30000.0
const DASH_SPEED = 50000

@onready var small_scare_sounds: AudioStreamPlayer = $SmallScareSounds
@onready var small_scare_hit_dealer: HitDealer = $HitDealer
@onready var small_scare_hit_dealer_collision_shape: CollisionShape2D = $HitDealer/CollisionShape
@onready var sprite: AnimatedSprite2D = $Sprite
@onready var da_pig: Sprite2D = $DaPig
@onready var settings_manager: SettingsManager = $/root/Main/SettingsManager
@onready var animation_player: AnimationPlayer = $SmallScareRecharge/AnimationPlayer
@onready var auto_targeter: AutoTargeter = $AutoTargeter
@onready var dashing_collision_shape: CollisionShape2D = $HitDealer/DashingCollisionShape
@onready var dashing_particles: GPUParticles2D = $DashingParticles

var small_scare_active = false
var dash_on_cooldown = false
var is_dashing = false

func _physics_process(delta: float) -> void:
	var direction := Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down").normalized()
	
	if direction:
		sprite.update_walking(true)
		sprite.update_direction_from_rad(Vector2().angle_to_point(direction) + PI / 4)
		sprite.flush_to_animation()
		linear_velocity = linear_velocity.normalized() * (linear_velocity.length() - delta * SPEED)
		linear_velocity += direction * delta * SPEED
		if is_dashing || small_scare_active:
			linear_velocity = Vector2(move_toward(linear_velocity.x, 0, delta * linear_velocity.length()), move_toward(linear_velocity.y, 0, delta * linear_velocity.length()))
	else:
		sprite.update_walking(false)
		sprite.flush_to_animation()
		linear_velocity = Vector2(move_toward(linear_velocity.x, 0, delta * SPEED), move_toward(linear_velocity.y, 0, delta * SPEED))
	
	if !direction:
		small_scare_hit_dealer.rotation = global_position.angle_to_point(auto_targeter.global_position) + PI
	
	if Input.is_action_just_pressed("small_scare") && !small_scare_active:
		if settings_manager.is_oink_mode_enabled():
			da_pig.visible = true
			get_tree().create_timer(1).timeout.connect(func(): da_pig.visible = false)
		
		animation_player.play("move_up")
		
		linear_velocity += (global_position.direction_to(auto_targeter.global_position) * delta * ATTACK_MINIDASH_SPEED) + Vector2(randf_range(-128, 128), randf_range(-128, 128))
		
		if !direction:
			sprite.update_direction_from_rad(small_scare_hit_dealer.rotation + PI * 1.25)
			sprite.flush_to_animation()
		
		small_scare_hit_dealer_collision_shape.disabled = false
		small_scare_active = true
		physics_material_override.bounce = 0.5
		get_tree().create_timer(0.2).timeout.connect(func(): small_scare_hit_dealer_collision_shape.disabled = true; small_scare_active = false; physics_material_override.bounce = 0.0)
		
		small_scare_sounds.play()
	
	if Input.is_action_just_pressed("dash") && !is_dashing && !dash_on_cooldown:
		if settings_manager.is_oink_mode_enabled():
			da_pig.visible = true
			get_tree().create_timer(1).timeout.connect(func(): da_pig.visible = false)
		
		var dash_movement_vector = direction * delta * DASH_SPEED if direction else global_position.direction_to(auto_targeter.global_position) * delta * DASH_SPEED
		
		linear_velocity += dash_movement_vector + Vector2(randf_range(-128, 128), randf_range(-128, 128))
		
		small_scare_hit_dealer.rotation = global_position.angle_to_point(dash_movement_vector) + PI
		
		if !direction:
			sprite.update_direction_from_rad(small_scare_hit_dealer.rotation + PI * 1.25)
			sprite.flush_to_animation()
		
		is_dashing = true
		dash_on_cooldown = true
		dashing_collision_shape.disabled = false
		dashing_particles.update_from_velocity(linear_velocity)
		dashing_particles.start_dash()
		get_tree().create_timer(0.3).timeout.connect(end_dash)
	
	if linear_velocity.length() != 0.0:
		auto_targeter.update_targeting()


func _on_hit_dealer_hit_landed(hitbox: HitBox, damage: float, hitbox_died: bool) -> void:
	if hitbox_died && Engine.time_scale != 0.5:
		Engine.time_scale = 0.5
		get_tree().create_timer(0.2).timeout.connect(func(): Engine.time_scale = 1.0)
	auto_targeter.set_combo_target(hitbox, 5.0)


func end_dash():
	if is_dashing:
		is_dashing = false
		dashing_collision_shape.set_deferred("disabled", true)
		dashing_particles.stop_dash()
		linear_velocity += Vector2(randf_range(-128, 128), randf_range(-128, 128))
		auto_targeter.update_targeting()
	if dash_on_cooldown:
		get_tree().create_timer(0.2).timeout.connect(func(): dash_on_cooldown = false)


func _on_body_entered(body: Node) -> void:
	end_dash()
