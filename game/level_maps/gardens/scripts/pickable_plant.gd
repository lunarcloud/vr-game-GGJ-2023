extends XRToolsPickable
class_name PickablePlant


onready var picked_audio = $PickedAudio
onready var animation_player : AnimationPlayer = get_node_or_null("AnimationPlayer")

var grabbed_by_hand := false
export var rotten := false
var watered := false

signal removed()
signal planted()


# Called when the node enters the scene tree for the first time.
func _ready():
	# warning-ignore:return_value_discarded
	connect("picked_up", self, "_on_picked_up")
	# warning-ignore:return_value_discarded
	connect("dropped", self, "_on_dropped")


# Called when picked up
func _on_picked_up(_pickable) -> void:
	picked_audio.play()

	if picked_up_by is XRToolsFunctionPickup:
		grabbed_by_hand = true

	elif not rotten and picked_up_by.is_in_group("goal_snap"):
		# No Replanting!
		enabled = false
		picked_up_by.enabled = false

		animation_player.play("JustPlanted")

		# Check if garden already watered
		var maybe_garden = picked_up_by.get_parent()
		if maybe_garden is Garden and maybe_garden.water_full:
			call_deferred("make_watered")

		emit_signal("planted")


func make_watered():
	if watered or rotten:
		return
	watered = true
	if animation_player.playback_active:
		animation_player.queue("Grow")
	else:
		animation_player.play("Grow")


# Called when dropped
func _on_dropped(_pickable) -> void:
	if not grabbed_by_hand or not rotten:
		return
	enabled = false
	emit_signal("removed")
	yield(get_tree().create_timer(1.0), "timeout")
	drop_and_free()
