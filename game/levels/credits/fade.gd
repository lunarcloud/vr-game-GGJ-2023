extends MeshInstance

onready var tween := get_tree().create_tween()


func fade_visible() -> void:
	tween.remove_all()
	tween.interpolate_method(self, "set_fade", 1.0, 0.0, 1.0)
	tween.start()
	yield(tween, "tween_all_completed")


func fade_black() -> void:
	tween.remove_all()
	tween.interpolate_method(self, "set_fade", 0.0, 1.0, 1.0)
	tween.start()
	yield(tween, "tween_all_completed")


## Fade
##
## Our fade object allows us to black out the screen for transitions.
## Note that our AABB is set to HUGE so it should always be rendered
## unless hidden.
func set_fade(p_value : float):
	if p_value == 0.0:
		visible = false
	else:
		var material : ShaderMaterial = get_surface_material(0)
		if material:
			material.set_shader_param("alpha", p_value)
		visible = true
