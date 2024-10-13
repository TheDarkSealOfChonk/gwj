extends CharacterBody2D


const SPEED = 300.0

@onready var hit_dealer: HitDealer = $HitDealer
@onready var hit_dealer_collision_shape: CollisionShape2D = $HitDealer/CollisionShape
@onready var sprite: AnimatedSprite2D = $Sprite

var scare_on_cooldown = false

func _physics_process(delta: float) -> void:
	if Input.is_action_just_pressed("shake") && !scare_on_cooldown:
		hit_dealer_collision_shape.disabled = false
		sprite.animation = "scare"
		scare_on_cooldown = true
		get_tree().create_timer(0.2).timeout.connect(func(): hit_dealer_collision_shape.disabled = true; sprite.animation = "idle")
		get_tree().create_timer(0.6).timeout.connect(func(): scare_on_cooldown = false)
	
	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction := Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down").normalized()
	if direction:
		velocity = direction * SPEED
	else:
		velocity = Vector2(move_toward(velocity.x, 0, SPEED), move_toward(velocity.y, 0, SPEED))
	
	move_and_slide()
