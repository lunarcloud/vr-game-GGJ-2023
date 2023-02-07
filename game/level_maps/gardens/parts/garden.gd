class_name Garden
extends Spatial

export(int, "none", "left", "right") var valve_side := 0

var water_full := false

func _on_valve_water_full(is_full: bool) -> void:
	water_full = is_full

	# now trigger the make_watered on plants already planted
	var children := get_children()
	for c in children:
		if c is XRToolsSnapZone:
			if is_instance_valid(c.picked_up_object) \
			and c.picked_up_object.has_method("make_watered"):
				c.picked_up_object.make_watered()
