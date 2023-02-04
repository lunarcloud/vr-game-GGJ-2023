extends Node

onready var zone_switch_area = $"../ZoneSwitchArea"
onready var victory_audio = $"../ComputerAIRepairStation/VictoryAudio"
onready var computer_ai_repair_station = $"../ComputerAIRepairStation"


func _on_GoodModules_all_modules_good():
	victory_audio.play()
	zone_switch_area.enable()
	computer_ai_repair_station.play_line(0) # todo
