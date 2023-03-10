tool
class_name ZoneSwitchArea
extends Area


## Zone scene file
export (String, FILE, '*.tscn') var zone_scene : String = ""

export var enable := true

# Called when the node enters the scene tree for the first time.
func _ready():
	# warning-ignore:return_value_discarded
	connect("body_entered", self, "_on_body_entered")


# Called when a body enters this area
func _on_body_entered(body : Spatial):
	# Skip if it wasn't the player entering
	if not enable or not body.is_in_group("player_body"):
		return

	# Find our scene base
	var scene_base : XRToolsSceneBase = XRTools.find_ancestor(self, "*", "XRToolsSceneBase")
	if not scene_base:
		return

	# Fire the load_scene signal
	if zone_scene == "":
		scene_base.reset_scene()
	else:
		scene_base.load_scene(zone_scene)


# Add support for is_class
func is_class(name : String) -> bool:
	return name == "ZoneSwitchArea" or .is_class(name)
