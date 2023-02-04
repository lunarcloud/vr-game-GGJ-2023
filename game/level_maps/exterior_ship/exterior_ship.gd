extends Spatial

export var modules_damaged := false

onready var repair_puzzle_area = $Core/BottomObjects/RepairPuzzleArea

func _ready():
	repair_puzzle_area.modules_damaged = modules_damaged
	repair_puzzle_area.update_children()
