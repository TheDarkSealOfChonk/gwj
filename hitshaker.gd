extends Node
class_name HitShaker


var shaking_skew = false
var shake_count = 0
const MAX_SHAKES = 5


func shake():
	if shaking_skew:
		shake_count = 0
	shaking_skew = true
	continue_shake()


func continue_shake():
	if shake_count == MAX_SHAKES:
		shake_count = 0
		shaking_skew = false
		get_parent().skew = 0.0
		return
	
	var current_shake_amount = TAU / (25 + ((shake_count % MAX_SHAKES) * 25))
	
	var skew_tween = get_tree().create_tween()
	
	skew_tween.tween_property(get_parent(), "skew", -(current_shake_amount + randf_range(-(TAU / 100), TAU / 100)), 0.03)
	skew_tween.tween_property(get_parent(), "skew", current_shake_amount + randf_range(-(TAU / 100), TAU / 100), 0.03)
	skew_tween.tween_callback(continue_shake)
	shake_count += 1
