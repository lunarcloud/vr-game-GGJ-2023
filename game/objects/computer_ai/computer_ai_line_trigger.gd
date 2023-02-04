extends Area

export var computer_ai_path : NodePath

var computer_ai : ComputerAiNpc

export var voice_line_on_enter : int = 0

export(int, "Off", "Idle", "Scream", "Talk", "NoChange") var face_on_enter : int = ComputerAiNpc.Faces.Talk

export var use_on_exit_line := false

export var voice_line_on_exit : int = 0

export var only_once := true

# Called when the node enters the scene tree for the first time.
func _ready():
	if !computer_ai_path:
		return

	var computer_ai = get_node_or_null(computer_ai_path)
	if !computer_ai:
		return

	self.connect("body_entered", self, "_on_body_entered_reemit", [], CONNECT_ONESHOT if only_once else 0)
	if use_on_exit_line:
		self.connect("body_exited", self, "_on_body_exited_reemit", [], CONNECT_ONESHOT if only_once else 0)


func _on_body_entered() -> void:
	computer_ai.play_line(voice_line_on_enter, face_on_enter)


func _on_body_exited() -> void:
	computer_ai.play_line(voice_line_on_exit, -1)
