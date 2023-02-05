extends XRToolsPickable
class_name PickablePlant


onready var picked_audio = $PickedAudio

var grabbed_by_hand := false
export var rotten := false

signal removed()
signal planted()


# Called when the node enters the scene tree for the first time.
func _ready():
	connect("picked_up", self, "_on_picked_up")
	connect("dropped", self, "_on_dropped")


# Called when picked up
func _on_picked_up(_pickable) -> void:
	picked_audio.play()

	if picked_up_by is XRToolsFunctionPickup:
		grabbed_by_hand = true

	elif not rotten and picked_up_by is XRToolsSnapZone:
		enabled = false
		emit_signal("planted")


# Called when dropped
func _on_dropped(_pickable) -> void:
	if not grabbed_by_hand or not rotten:
		return
	enabled = false
	emit_signal("removed")
	yield(get_tree().create_timer(1.0), "timeout")
	drop_and_free()
