extends Node


onready var ai_speech_trigger_instruction = $"../ComputerAI/AiSpeechTriggerInstruction"

onready var ai_speech_trigger_back_for_help = $"../ComputerAI/AiSpeechTriggerBackForHelp"

onready var computer_ai = $"../ComputerAI"

onready var exit_to_credits_a = $"../ExitToCreditsA"

onready var exit_to_credits_b = $"../ExitToCreditsB"


var total_plants := 0

var progress_plants := 0


signal completed_mission()



func _ready():
	computer_ai.connect("finished_talking", self, "_on_player_left_ai", [], CONNECT_ONESHOT)
	var plants = get_tree().get_nodes_in_group("plant")
	for plant in plants:
		if plant.rotten == false:
			total_plants += 1
		plant.connect("planted", self, "_on_plant_planted", [], CONNECT_ONESHOT)


func _on_player_left_ai(_body):
	ai_speech_trigger_instruction.enabled = false
	yield(get_tree().create_timer(10.0), "timeout")
	ai_speech_trigger_back_for_help.enabled = true


func _on_plant_planted() -> void:
	progress_plants += 1
	if progress_plants >= total_plants:
		ai_speech_trigger_instruction.enabled = false
		ai_speech_trigger_back_for_help.enabled = false
		emit_signal("completed_mission")
		computer_ai.play_line(2, ComputerAiNpc.Faces.Talk)
		computer_ai.connect("finished_talking", self, "_on_enable_exit", [], CONNECT_ONESHOT)


func _on_enable_exit() -> void:
	exit_to_credits_a.enable = true
	exit_to_credits_b.enable = true
