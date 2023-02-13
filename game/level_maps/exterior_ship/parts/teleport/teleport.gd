tool
extends Spatial

export var enable := true setget set_active, get_active


func set_active(value: bool):
	$TeleportArea.visible = value 
	$TeleportBody/Base.get_active_material(0).emission_enabled = value


func get_active() -> bool:
	return $TeleportArea.visible 
