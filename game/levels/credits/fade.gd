extends MeshInstance

onready var tween : SceneTreeTween

export var initially_black := false

export var fade_at_start := false

## Called when the node enters the scene tree for the first time.
func _ready() -> void:
	set_fade(1 if initially_black else 0)
	if fade_at_start:
		fade_black()


func fade_visible() -> void:
	if tween:
		tween.kill()
	tween = get_tree().create_tween()
	tween.tween_method(self, "set_fade", 1.0, 0.0, 1.0)


func fade_black() -> void:
	if tween:
		tween.kill()
	tween = get_tree().create_tween()
	tween.tween_method(self, "set_fade", 0.0, 1.0, 1.0)


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
