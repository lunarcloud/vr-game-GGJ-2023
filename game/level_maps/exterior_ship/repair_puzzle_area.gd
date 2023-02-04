extends Spatial

export var modules_damaged := false

onready var modules = $Modules

func _ready():
	update_children()

func update_children():
	for child in modules.get_children():
		child.damaged = modules_damaged
		child.inserted = true
		child._update_accent()
