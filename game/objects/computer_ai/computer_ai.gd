tool
class_name ComputerAiNpc
extends Spatial

onready var terminal : MeshInstance = $Terminal
onready var audio : AudioStreamPlayer3D = $Audio
onready var face : AnimatedSprite3D = $Face

# Set this if you want the scene to start with the computer talking
var current_audio : AudioStream setget _set_audio, _get_audio

export(Array, AudioStream) var audio_streams : Array

export var play_first_audio_at_start := false

export var autoplay_delay := 2.0

# Whether you want the computer to be initially active
export var face_visible := true setget set_face_visible, _get_face_visible

# Turn this off if your scene already has a terminal with baked lighting
export var terminal_visible := false setget _terminal_visible_toggle, _get_terminal_visible

enum Faces {
	Off = 0,
	Idle = 1,
	Scream = 2,
	Talk = 3,
	Humming = 4,
	NoChange = 5
}

signal finished_talking()

# Called when the node enters the scene tree for the first time.
func _ready():
	update_animation(Faces.Idle if face_visible else Faces.Off)

	if Engine.editor_hint:
		return

	# warning-ignore:return_value_discarded
	audio.connect("finished", self, "_on_audio_finished")

	if play_first_audio_at_start:
		yield(get_tree().create_timer(autoplay_delay), "timeout")
		play_line(0, Faces.Talk)


func _on_audio_finished() -> void:
	if face_visible:
		update_animation(Faces.Idle)
		emit_signal("finished_talking")


func _get_audio() -> AudioStream:
	if not is_instance_valid(audio):
		audio = $Audio
	return audio.stream if is_instance_valid(audio) else null


func _set_audio(new_value: AudioStream) -> void:
	if not is_instance_valid(audio):
		audio = $Audio
	if not is_instance_valid(audio):
		return

	audio.stream = new_value

	if new_value != null:
		face_visible = true
		if Engine.editor_hint:
			play_first_audio_at_start = true


func set_face_visible(new_value : bool) -> void:
	face_visible = new_value
	if not is_instance_valid(face):
		face = $Face

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

func play_line(index: int, expression: int) -> void:
	update_animation(expression)
	audio.stop()
	if index < 0:
		emit_signal("finished_talking") # this was forced on purpose
	else:
		_set_audio(audio_streams[index])
		audio.play()


func update_animation(expression: int) -> void:
	if expression == Faces.NoChange:
		return

	face.visible = expression != Faces.Off

	match expression:
		Faces.Scream:
			face.play("screaming")
		Faces.Talk:
			face.play("talking")
		Faces.Humming:
			face.play("humming")
		_:
			face.play( "default")
