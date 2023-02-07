extends Spatial

onready var valve_pipe_1 = $"Structure/Valve & Pipe Left"
onready var valve_pipe_2 = $"Structure/Valve & Pipe Right"

# Left Gardens
onready var garden_2 = $Structure/Garden1
onready var garden_3 = $Structure/Garden3

# Right Gardens
onready var garden_1 = $Structure/Garden2
onready var garden_4 = $Structure/Garden4

var _valves_on := 0

signal valve_changed(index, on)
signal all_valves_changed(on)


# Called when the node enters the scene tree for the first time.
func _ready():
	valve_pipe_1.connect("water_full", self, "_on_valve_changed", [1])
	valve_pipe_2.connect("water_full", self, "_on_valve_changed", [2])


func _on_valve_changed(on: bool, index: int) -> void:
	_valves_on += 1 if on else -1

	emit_signal("all_valves_changed", _valves_on == 2)
	emit_signal("valve_changed", index, on)


func get_left_planted_plants() -> Array:
	return garden_2.get_planted_plants() \
		.append_array(garden_3.get_planted_plants())


func get_right_planted_plants() -> Array:
	return garden_1.get_planted_plants() \
		.append_array(garden_4.get_planted_plants())
