tool
extends Spatial

onready var water = $WaterFillPipe/Water
onready var valve = $ValveAssembly/Valve

export var water_level : float = 0 setget change_water_level
export var zero_water_y := -1.12
export var full_water_y := 1.852

signal water_level_changed(percent)

func _ready():
	change_water_level(water_level)

func change_water_level(amount: float) -> void:
	if amount < 0 or amount > 1:
		push_warning("Cannot make water anything not between 0 and 1")
		return
	water_level = amount

	if not is_inside_tree():
		return

	water.translation.y = lerp(zero_water_y, full_water_y, amount)
	emit_signal("water_level_changed", amount)
