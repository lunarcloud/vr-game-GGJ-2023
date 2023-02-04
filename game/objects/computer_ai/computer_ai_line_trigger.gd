extends Area

export var computer_ai_path : NodePath

var computer_ai : ComputerAiNpc

export var voice_line_on_enter : int = 0

export var use_on_exit_line := false

export var voice_line_on_exit : int = 0


# Called when the node enters the scene tree for the first time.
func _ready():
	if !computer_ai_path:
		return

	var computer_ai = get_node_or_null(computer_ai_path)
	if !computer_ai:
		return

	self.connect("body_entered", self, "_on_body_entered_reemit")
	self.connect("body_exited", self, "_on_body_exited_reemit")


func _on_body_entered() -> void:
	computer_ai.current_audio = computer_ai.audio_streams[voice_line_on_enter]


func _on_body_exited() -> void:
	if not use_on_exit_line:
		return
	computer_ai.current_audio = computer_ai.audio_streams[voice_line_on_exit]
