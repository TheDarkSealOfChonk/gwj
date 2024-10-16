extends AnimatedSprite2D
class_name AutoTargeter


@export var origin_node: Node2D

var combo_target: Node2D
var combo_timer: Timer = Timer.new()


func _ready() -> void:
	add_child(combo_timer)
	combo_timer.timeout.connect(func(): combo_target = null)


func _notification(what: int) -> void:
	match what:
		NOTIFICATION_WM_MOUSE_EXIT:
			visible = false
		NOTIFICATION_WM_MOUSE_ENTER:
			visible = true


func _input(event: InputEvent) -> void:
	if event is InputEventMouse:
		update_targeting()
	if event is InputEventMouseButton && combo_target && is_instance_valid(combo_target):
		var angle_difference = abs(origin_node.global_position.angle_to_point(combo_target.global_position) - origin_node.global_position.angle_to_point(get_global_mouse_position()))
		if angle_difference > PI / 4 && combo_target.global_position.distance_to(origin_node.global_position) > 16:
			combo_target = null
			update_targeting()
			combo_timer.stop()


func update_targeting():
	if combo_target && is_instance_valid(combo_target):
		frame = 1
		global_position = combo_target.global_position
	else:
		var target: Node2D
		var last_angle_difference: float
		var last_distance: float
		for node in get_tree().get_nodes_in_group("targets"):
			if node is Node2D:
				var angle_difference = abs(origin_node.global_position.angle_to_point(node.global_position) - origin_node.global_position.angle_to_point(get_global_mouse_position()))
				var distance = node.global_position.distance_to(get_global_mouse_position())
				if angle_difference < PI / 16 && distance <= 64:
					if !target:
						target = node
						last_angle_difference = angle_difference
						last_distance = distance
					elif angle_difference < last_angle_difference:
						if distance <= last_distance:
							target = node
							last_angle_difference = angle_difference
							last_distance = distance
		
		if target:
			frame = 1
			global_position = target.global_position
		else:
			frame = 0
			global_position = get_global_mouse_position()


func set_combo_target(node: Node2D, duration: float):
	combo_target = node
	combo_timer.start(duration)
