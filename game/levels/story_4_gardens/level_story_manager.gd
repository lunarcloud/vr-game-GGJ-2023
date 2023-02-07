extends Node


onready var computer_ai = $"../ComputerAIMiddle"

onready var gardens = $"../Gardens"

onready var exit_to_credits_a = $"../ExitToCreditsA"

onready var exit_to_credits_b = $"../ExitToCreditsB"

var total_plants := 0
var progress_plants := 0

var left_valve_on := false
var right_valve_on := false

var _mission_complete := false

signal completed_mission()



func _ready():
	gardens.connect("valve_changed", self, "_on_valve_changed")

	var plants = get_tree().get_nodes_in_group("plant")
	for plant in plants:
		if plant.rotten == false:
			total_plants += 1
		plant.connect("planted", self, "_on_plant_planted", [], CONNECT_ONESHOT)




func _on_plant_planted() -> void:
	progress_plants += 1
	_maybe_completed()


func _on_valve_changed(valve: int, is_on: bool) -> void:
	if valve == 1:
		left_valve_on = is_on
	if valve == 2:
		right_valve_on = is_on
	_maybe_completed()


func _maybe_completed():
	if _mission_complete \
	or progress_plants < total_plants \
	or not left_valve_on or not right_valve_on:
		return

	_mission_complete = true
	emit_signal("completed_mission")
	computer_ai.play_line(1, ComputerAiNpc.Faces.Talk)
	computer_ai.connect("finished_talking", self, "_on_enable_exit", [], CONNECT_ONESHOT)


func _on_enable_exit() -> void:
	exit_to_credits_a.enable = true
	exit_to_credits_b.enable = true
