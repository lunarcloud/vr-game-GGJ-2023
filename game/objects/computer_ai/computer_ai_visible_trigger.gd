extends Area

enum Visibility {
	Off,
	On,
	NoChange
}

export var computer_ai_path : NodePath

var computer_ai : ComputerAiNpc

export(int, "On", "Off", "No Change") var visible_on_enter : int = Visibility.On

export(int, "On", "Off", "No Change") var visible_on_exit : int = Visibility.NoChange


# Called when the node enters the scene tree for the first time.
func _ready():
	if !computer_ai_path:
		return

	var computer_ai = get_node_or_null(computer_ai_path)
	if !computer_ai:
		return

	if visible_on_enter != Visibility.NoChange:
		self.connect("body_entered", computer_ai, "set_face_visible", [visible_on_enter == Visibility.On])

	if visible_on_exit != Visibility.NoChange:
		self.connect("body_exited", computer_ai, "set_face_visible", [visible_on_exit == Visibility.On])

