extends Spatial

var module_1_good := false
var module_2_good := false
var module_3_good := false

signal all_modules_good()


func notify_if_all_good():
	if module_1_good and module_2_good and module_3_good:
		emit_signal("all_modules_good")


func _on_Module1_insert_changed(value):
	module_1_good = value
	notify_if_all_good()


func _on_Module2_insert_changed(value):
	module_2_good = value
	notify_if_all_good()


func _on_Module3_insert_changed(value):
	module_3_good = value
	notify_if_all_good()
