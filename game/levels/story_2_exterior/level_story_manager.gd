extends Node

onready var zone_switch_area := $"../ZoneSwitchArea"
onready var victory_audio := $"../ComputerAIRepairStation/VictoryAudio"
onready var computer_ai_repair_station : ComputerAiNpc = $"../ComputerAIRepairStation"

export var victory_computer_ai_line := 1

func _on_GoodModules_all_modules_good():
	victory_audio.connect("finished", self, "_on_victory_finished", [], CONNECT_ONESHOT)
	victory_audio.play()
	zone_switch_area.enable = true


func _on_victory_finished():
	computer_ai_repair_station.play_line(victory_computer_ai_line, ComputerAiNpc.Faces.Talk)
