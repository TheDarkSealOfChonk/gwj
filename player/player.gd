extends RigidBody2D


const SPEED = 3000.0
const ATTACK_MINIDASH_SPEED = 15000.0
const DASH_SPEED = 50000

@onready var small_scare_sounds: AudioStreamPlayer = $SmallScareSounds
@onready var small_scare_hit_dealer: HitDealer = $HitDealer
@onready var small_scare_hit_dealer_collision_shape: CollisionShape2D = $HitDealer/CollisionShape
@onready var sprite: AnimatedSprite2D = $Sprite
@onready var da_pig: Sprite2D = $DaPig
@onready var settings_manager: SettingsManager = $/root/Main/SettingsManager
@onready var animation_player: AnimationPlayer = $SmallScareRecharge/AnimationPlayer

var small_scare_on_cooldown = false
var dash_on_cooldown = false
var is_dashing = false

func _physics_process(delta: float) -> void:
	var direction := Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down").normalized()
	
	if direction:
		sprite.update_walking(true)
		sprite.update_direction_from_rad(Vector2().angle_to_point(direction))
		sprite.flush_to_animation()
		linear_velocity = linear_velocity.normalized() * (linear_velocity.length() - delta * SPEED)
		linear_velocity += direction * delta * SPEED
		if is_dashing:
			linear_velocity = Vector2(move_toward(linear_velocity.x, 0, delta * SPEED), move_toward(linear_velocity.y, 0, delta * SPEED))
	else:
		sprite.update_walking(false)
		sprite.flush_to_animation()
		linear_velocity = Vector2(move_toward(linear_velocity.x, 0, delta * SPEED), move_toward(linear_velocity.y, 0, delta * SPEED))
	
	small_scare_hit_dealer.rotation = global_position.angle_to_point(get_global_mouse_position()) + PI
	
	if Input.is_action_just_pressed("small_scare") && !small_scare_on_cooldown:
		if settings_manager.is_oink_mode_enabled():
			da_pig.visible = true
			get_tree().create_timer(1).timeout.connect(func(): da_pig.visible = false)
		
		animation_player.play("move_up")
		
		linear_velocity += global_position.direction_to(get_global_mouse_position()) * delta * ATTACK_MINIDASH_SPEED
		
		sprite.update_direction_from_rad((small_scare_hit_dealer.rotation - PI if small_scare_hit_dealer.rotation >= PI else small_scare_hit_dealer.rotation + PI) + (PI / 4))
		sprite.flush_to_animation()
		
		small_scare_hit_dealer_collision_shape.disabled = false
		small_scare_on_cooldown = true
		get_tree().create_timer(0.2).timeout.connect(func(): small_scare_hit_dealer_collision_shape.disabled = true; small_scare_on_cooldown = false)
		
		small_scare_sounds.play()
	
	if Input.is_action_just_pressed("dash") && !is_dashing:
		if settings_manager.is_oink_mode_enabled():
			da_pig.visible = true
			get_tree().create_timer(1).timeout.connect(func(): da_pig.visible = false)
		
		var dash_movement_vector = direction * delta * DASH_SPEED if direction else global_position.direction_to(get_global_mouse_position()) * delta * DASH_SPEED
		
		linear_velocity += dash_movement_vector
		
		small_scare_hit_dealer.rotation = global_position.angle_to_point(dash_movement_vector) + PI
		
		sprite.update_direction_from_rad((small_scare_hit_dealer.rotation - PI if small_scare_hit_dealer.rotation >= PI else small_scare_hit_dealer.rotation + PI) + (PI / 4))
		sprite.flush_to_animation()
		
		is_dashing = true
		get_tree().create_timer(0.5).timeout.connect(func(): is_dashing = false)
