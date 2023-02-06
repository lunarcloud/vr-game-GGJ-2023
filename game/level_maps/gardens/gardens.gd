extends Spatial

onready var valve_pipe_1 = $"Structure/Valve & Pipe"
onready var valve_pipe_2 = $"Structure/Valve & Pipe2"

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
