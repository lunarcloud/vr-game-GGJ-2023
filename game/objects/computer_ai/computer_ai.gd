extends Spatial

onready var conversation_area : Area = $ConversationArea
onready var terminal : MeshInstance = $Terminal
onready var audio : AudioStreamPlayer3D = $Audio
onready var animation_player : AnimationPlayer = $AnimationPlayer

export var initial_audio : AudioStream

# Called when the node enters the scene tree for the first time.
func _ready():
	conversation_area.connect("body_entered", self, "_on_conversation_area_entered")
	conversation_area.connect("body_exited", self, "_on_conversation_area_exited")
	audio.connect("finished", self, "update_animation", ["stop"])

	if is_instance_valid(initial_audio):
		audio.stream = initial_audio
		audio.play()
		update_animation("talking") # TODO


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func update_animation(anim: String) -> void:
	if anim == "stop":
		animation_player.stop()
	else:
		return #TODO


func _on_conversation_area_entered(body: Node) -> void:
	pass


func _on_conversation_area_exited(body: Node) -> void:
	pass
