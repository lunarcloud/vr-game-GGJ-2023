class_name Garden
extends Spatial

export(int, "none", "left", "right") var valve_side := 0

export(float, 0.0, 10, 3.0) var valve_on_plant_grow_delay : float = 3.0

var water_full := false

func _on_valve_water_full(is_full: bool) -> void:
	water_full = is_full

	# now trigger the make_watered on plants already planted
	var children := get_children()
	var plants = []
	for c in children:
		if c is XRToolsSnapZone:
			if is_instance_valid(c.picked_up_object) \
			and c.picked_up_object.has_method("make_watered"):
				plants.append(c.picked_up_object)
	call_deferred("_wait_then_water", plants)

func _wait_then_water(plants):
	yield(get_tree().create_timer(valve_on_plant_grow_delay), "timeout")
	for plant in plants:
		plant.make_watered()
