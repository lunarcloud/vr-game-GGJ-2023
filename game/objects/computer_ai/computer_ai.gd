tool
class_name ComputerAiNpc
extends Spatial

onready var conversation_area : Area = $ConversationArea
onready var terminal : MeshInstance = $Terminal
onready var audio : AudioStreamPlayer3D = $Audio
onready var face : AnimatedSprite3D = $Face

# Set this if you want the scene to start with the computer talking
var current_audio : AudioStream setget _audio_update, _get_audio

export(Array, AudioStream) var audio_streams : Array

export var play_first_audio_at_start := false

# Whether you want the computer to be initially active
export var face_visible := true setget set_face_visible, _get_face_visible

# Turn this off if your scene already has a terminal with baked lighting
export var terminal_visible := false setget _terminal_visible_toggle, _get_terminal_visible

enum Faces {
	Off = 0,
	Idle,
	Scream,
	Talk
}


# Called when the node enters the scene tree for the first time.
func _ready():
	update_animation(Faces.Idle)

	if Engine.editor_hint:
		return

	conversation_area.connect("body_entered", self, "_on_conversation_area_entered")
	conversation_area.connect("body_exited", self, "_on_conversation_area_exited")
	audio.connect("finished", self, "update_animation", [Faces.Idle])

	if play_first_audio_at_start:
		audio.play()
		update_animation(Faces.Talk)


func _get_audio() -> AudioStream:
	return audio.stream


func _audio_update(new_value: AudioStream) -> void:
	audio.stream = new_value
	if current_audio != null:
		face_visible = true
		if Engine.editor_hint:
			play_first_audio_at_start = true


func set_face_visible(new_value : bool) -> void:
	if not is_instance_valid(face):
		face = $Face
	if not new_value and current_audio != null:
		face_visible = true
		return
	if is_instance_valid(face):
		face.visible = new_value


func _terminal_visible_toggle(new_value : bool) -> void:
	if not is_instance_valid(terminal):
		terminal = $Terminal
	if is_instance_valid(terminal):
		terminal.visible = new_value


func _get_face_visible() -> bool:
	if not is_instance_valid(face):
		face = $Face
	return face.visible


func _get_terminal_visible() -> bool:
	if not is_instance_valid(terminal):
		terminal = $Terminal
	return terminal.visible


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func update_animation(expression: int) -> void:
	face_visible = expression != Faces.Off
	match expression:
		Faces.Scream:
			face.animation = "screaming"
		Faces.Talk:
			face.animation = "talking"
		_:
			face.animation = "default"


func _on_conversation_area_entered(body: Node) -> void:
	if Engine.editor_hint:
		return
	pass


func _on_conversation_area_exited(body: Node) -> void:
	if Engine.editor_hint:
		return
	pass
