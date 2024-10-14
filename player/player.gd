extends CharacterBody2D


const SPEED = 300.0

@onready var SMALL_SCARE_SOUNDS = [
	$SmallScareSounds/Sound01,
	$SmallScareSounds/Sound02,
	$SmallScareSounds/Sound03,
]

@onready var small_scare_hit_dealer: HitDealer = $HitDealer
@onready var small_scare_hit_dealer_collision_shape: CollisionShape2D = $HitDealer/CollisionShape
@onready var sprite: AnimatedSprite2D = $Sprite
@onready var da_pig: Sprite2D = $DaPig
@onready var settings_manager: SettingsManager = $/root/Main/SettingsManager

var scare_on_cooldown = false

func _physics_process(delta: float) -> void:
	small_scare_hit_dealer.rotation = global_position.angle_to_point(get_global_mouse_position()) + PI
	
	if Input.is_action_just_pressed("small_scare") && !scare_on_cooldown:
		if settings_manager.is_oink_mode_enabled():
			da_pig.visible = true
			get_tree().create_timer(1).timeout.connect(func(): da_pig.visible = false)
		
		sprite.update_direction_from_rad(small_scare_hit_dealer.rotation)
		sprite.flush_to_animation()
		
		small_scare_hit_dealer_collision_shape.disabled = false
		scare_on_cooldown = true
		get_tree().create_timer(0.2).timeout.connect(func(): small_scare_hit_dealer_collision_shape.disabled = true)
		get_tree().create_timer(0.6).timeout.connect(func(): scare_on_cooldown = false)
		
		SMALL_SCARE_SOUNDS[randi_range(0, 2)].play()
	
	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction := Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down").normalized()
	
	if direction:
		sprite.update_walking(true)
		sprite.update_direction_from_rad(Vector2().angle_to_point(direction))
		sprite.flush_to_animation()
		velocity = direction * SPEED
	else:
		sprite.update_walking(false)
		sprite.flush_to_animation()
		velocity = Vector2(move_toward(velocity.x, 0, SPEED), move_toward(velocity.y, 0, SPEED))
	
	move_and_slide()
