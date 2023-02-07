extends Spatial

onready var water_flowing_sound = $WaterFlowingSound
onready var animation_player = $AnimationPlayer

export var is_full := false

signal water_level_changed(percent)
signal water_full(is_full)

func change_water_level(amount: float) -> void:
	if amount < 0 or amount > 1:
		push_warning("Cannot make water anything not between 0 and 1")
		return

	if amount < 1:
		amount = 0

	if not is_inside_tree():
		return

	var now_full := amount >= 0.99
	if is_full == now_full:
		return
	is_full = now_full

	if now_full:
		animation_player.play("OffToFullOn")
		water_flowing_sound.play()
	else:
		animation_player.play("OnToOff")
		water_flowing_sound.stop()

	emit_signal("water_level_changed", amount)
	emit_signal("water_full", now_full)


func _on_valve_hinge_moved(angle):
	change_water_level(angle / 360)
