tool
extends Spatial

export var countdown := 4

export var mesh_size : float = 0.001 setget _update_mesh_size

export(Array, Material) var materials := [] setget _update_materials

# Activate to transition from older non-generated shader cache
#export var grab_materials : bool = false setget _grab_materials

signal cooldown_finished


func _enter_tree():
	if Engine.editor_hint:
		_create_material_nodes()


# Only used to transition from older non-generated shader cache
func _grab_materials(_unused):
	if not Engine.editor_hint:
		return
	print("Grabbing materials...")
	materials = []

	var children := get_children()
	var total := children.size()

	for index in range(total):
		materials.append(children[index].get_active_material(0))


func _update_materials(new_materials: Array) -> void:
	if not Engine.editor_hint:
		return
	materials = new_materials
	_create_material_nodes()


func _update_mesh_size(new_size: float) -> void:
	mesh_size = new_size
	_create_material_nodes()


func _create_material_nodes() -> void:
	print("Creating material cache nodes...")

	var total := materials.size()

	var near_clip := 0.05 if not get_parent() is Camera else get_parent().near
	var grid_space : float = mesh_size * 1.1
	# warning-ignore:narrowing_conversion
	var grid_rows := int(floor(sqrt(total)))
	if grid_rows <= 0:
		return
	var grid_columns := int(floor(total / grid_rows))


	while get_child_count() > 0:
		remove_child(get_child(0))

	var material_meshes := Spatial.new()
	add_child(material_meshes)
	material_meshes.set_owner(self)
	material_meshes.translation = Vector3(
		(-0.5 * grid_space * grid_columns) + (grid_space / 2),
		(-0.5 * grid_space * grid_rows) + (grid_space / 2),
		-1 * (near_clip + 0.001) # farther than near clipping
	)

	var common_mesh := PlaneMesh.new()
	common_mesh.size = Vector2(mesh_size, mesh_size)

	for index in range(total):
		var node := MeshInstance.new()
		material_meshes.add_child(node)
		node.set_owner(self)

		node.mesh = common_mesh
		node.set_surface_material(0,  materials[index])
		node.rotation = Vector3(deg2rad(90), 0, 0)
		node.translation = grid_space * Vector3(
			index / grid_columns,
			index % grid_rows,
			0
		)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	if Engine.editor_hint:
		return
	countdown = countdown - 1
	if countdown == 0:
		visible = false
		set_process(false)
		emit_signal("cooldown_finished")
