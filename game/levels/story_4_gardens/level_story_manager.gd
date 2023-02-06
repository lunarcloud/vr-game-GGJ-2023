extends Node


onready var ai_speech_trigger_instruction = $"../ComputerAI/AiSpeechTriggerInstruction"

onready var ai_speech_trigger_back_for_help = $"../ComputerAI/AiSpeechTriggerBackForHelp"

onready var computer_ai = $"../ComputerAIMiddle"

onready var gardens = $"../Gardens"

onready var exit_to_credits_a = $"../ExitToCreditsA"

onready var exit_to_credits_b = $"../ExitToCreditsB"


var total_plants := 0

var progress_plants := 0

var all_valves_on := false

var _mission_complete := false

signal completed_mission()



func _ready():
	gardens.connect("all_valves_changed", self, "_on_all_valves_change")

	var plants = get_tree().get_nodes_in_group("plant")
	for plant in plants:
		if plant.rotten == false:
			total_plants += 1
		plant.connect("planted", self, "_on_plant_planted", [], CONNECT_ONESHOT)



func _on_plant_planted() -> void:
	progress_plants += 1
	_maybe_completed()


func _on_all_valves_change(new_value: bool) -> void:
	all_valves_on = new_value
	_maybe_completed()


func _maybe_completed():
	if _mission_complete or progress_plants < total_plants or not all_valves_on:
		return

	_mission_complete = true
	emit_signal("completed_mission")
	computer_ai.play_line(1, ComputerAiNpc.Faces.Talk)
	computer_ai.connect("finished_talking", self, "_on_enable_exit", [], CONNECT_ONESHOT)


func _on_enable_exit() -> void:
	exit_to_credits_a.enable = true
	exit_to_credits_b.enable = true
