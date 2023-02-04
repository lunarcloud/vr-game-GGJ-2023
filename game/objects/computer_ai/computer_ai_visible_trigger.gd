extends Area

enum Visibility {
	Off = 0,
	On = 1,
	NoChange = -1
}

export var computer_ai_path : NodePath

var computer_ai : ComputerAiNpc

export(int, "On", "Off", "No Change") var visibility_on_enter : int = Visibility.On

export(int, "On", "Off", "No Change") var visibility_on_exit : int = Visibility.NoChange

export var only_once := true

# Called when the node enters the scene tree for the first time.
func _ready():
	if !computer_ai_path:
		return

	var computer_ai = get_node_or_null(computer_ai_path)
	if !computer_ai:
		return

	if visibility_on_enter != Visibility.NoChange:
		self.connect("body_entered", computer_ai, "set_face_visible", [visibility_on_enter == Visibility.On], CONNECT_ONESHOT if only_once else 0)

	if visibility_on_exit != Visibility.NoChange:
		self.connect("body_exited", computer_ai, "set_face_visible", [visibility_on_exit == Visibility.On], CONNECT_ONESHOT if only_once else 0)

