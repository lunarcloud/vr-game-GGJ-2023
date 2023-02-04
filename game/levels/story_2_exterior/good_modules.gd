extends Spatial

var module_1_good := false
var module_2_good := false
var module_3_good := false

signal all_modules_good()

func notify_if_all_good():
	emit_signal("all_modules_good")

func _on_Module1_insert_changed(value):
	module_1_good = value


func _on_Module2_insert_changed(value):
	module_2_good = value


func _on_Module3_insert_changed(value):
	module_3_good = value
