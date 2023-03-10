class_name RepairModule
extends XRToolsPickable

onready var props_capsule = $Props_Capsule

onready var pickup_sound = $PickupSound

onready var activate_sound = $ActivateSound


var damaged_accent : Material = preload("res://game/objects/repair_module/damaged_accent.tres")

var powered_accent : Material = preload("res://game/objects/repair_module/powered_accent.tres")

var normal_accent : Material = preload("res://addons/quaternius-modular-scifi/modular/materials/accent.tres")


export var damaged := false

export var inserted := false


var current_accent : Material

var _grabbed_by_hand := false


signal insert_changed(value)


# Called when the node enters the scene tree for the first time.
func _ready():
	props_capsule.set_surface_material(1, normal_accent)
	_update_accent()
	# warning-ignore:return_value_discarded
	connect("picked_up", self, "_on_picked_up")
	connect("dropped", self, "_on_dropped")



# Add support for is_class
func is_class(name : String) -> bool:
	return name == "RepairModule" or .is_class(name)


func _update_accent() -> void:
	current_accent = normal_accent if not inserted \
		else damaged_accent if damaged \
		else powered_accent
	props_capsule.set_surface_material(1, current_accent)


func _on_picked_up(_pickable) -> void:
	# Detect pickup by player
	if picked_up_by is XRToolsFunctionPickup:
		_grabbed_by_hand = true

	# Detect picked up by snap-zone
	inserted = picked_up_by is XRToolsSnapZone

	_update_accent()
	if inserted and not damaged:
		activate_sound.play()
	else:
		pickup_sound.play()
	emit_signal("insert_changed", inserted)


func _on_dropped(_pickable) -> void:
	if damaged and _grabbed_by_hand:
		yield(get_tree().create_timer(1.0), "timeout")
		if is_instance_valid(self):
			drop_and_free()
