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

signal insert_changed(value)

# Called when the node enters the scene tree for the first time.
func _ready():
	props_capsule.set_surface_material(1, normal_accent)
	_update_accent()
	# warning-ignore:return_value_discarded
	connect("picked_up", self, "_on_picked_up")


func _update_accent() -> void:
	current_accent = normal_accent if not inserted \
		else damaged_accent if damaged \
		else powered_accent
	props_capsule.set_surface_material(1, current_accent)


func _on_picked_up(_pickable) -> void:
	inserted = picked_up_by is XRToolsSnapZone
	_update_accent()
	if inserted and not damaged:
		activate_sound.play()
	else:
		pickup_sound.play()
	emit_signal("insert_changed", inserted)
