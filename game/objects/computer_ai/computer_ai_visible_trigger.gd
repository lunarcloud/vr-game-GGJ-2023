extends Area

enum Visibility {
	Off = 0,
	On = 1,
	NoChange = -1
}

export var computer_ai_path : NodePath

var computer_ai : ComputerAiNpc

export(int, "Off", "On", "No Change") var visibility_on_enter : int = Visibility.On

export(int, "Off", "On", "No Change") var visibility_on_exit : int = Visibility.NoChange

export var only_once := true

# Called when the node enters the scene tree for the first time.
func _ready():
	if !computer_ai_path:
		push_error("Computer AI path not set!")
		return

	computer_ai = get_node_or_null(computer_ai_path)
	if !computer_ai:
		push_error("Computer AI node not found!")
		return

	if visibility_on_enter != Visibility.NoChange:
		# warning-ignore:return_value_discarded
		self.connect("body_entered", self, "_on_body_entered", [], CONNECT_ONESHOT if only_once else 0)

	if visibility_on_exit != Visibility.NoChange:
		# warning-ignore:return_value_discarded
		self.connect("body_exited", self, "_on_body_entered", [], CONNECT_ONESHOT if only_once else 0)


func _on_body_entered(_body) -> void:
	computer_ai.set_face_visible(visibility_on_enter == Visibility.On)


func _on_body_exited(_body) -> void:
	computer_ai.set_face_visible(visibility_on_exit == Visibility.On)
