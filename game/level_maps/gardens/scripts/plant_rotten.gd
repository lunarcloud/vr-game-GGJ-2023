extends XRToolsPickable


# Called when the node enters the scene tree for the first time.
func _ready():
	connect("picked_up", self, "_on_picked_up")

# Called when picked up
func _on_picked_up(_pickable) -> void:
	if picked_up_by is XRToolsFunctionPickup:
		connect("dropped", self, "_on_dropped")

# Called when dropped
func _on_dropped(_pickable) -> void:
	yield(get_tree().create_timer(1.0), "timeout")
	drop_and_free()
