class_name TimeWiper
extends Node

@export var rotation_speed_deg: float = 30.0
@export var disks: Array[Disk]
## current wipe angle in rad
@export var colors: Array[Color]
@export var object_colors: Array[Color]
var progress: float
var curr_start_id: int = 0
var wipe_angle: float = 0.0

var objects_being_wiped: Dictionary[Node3D, MeshInstance3D] = {}
@onready var disk_count: int = disks.size()
func _ready():
	set_wipeable_bodies_color()
	for i in range(disks.size()):
		disks[i].wiper.body_entered.connect(body_entered_on_wiper_area_x.bind(i))
		disks[i].wiper.area_entered.connect(body_entered_on_wiper_area_x.bind(i))
		disks[i].wiper.body_exited.connect(body_exited_wiper_area_x.bind(i))
		disks[i].wiper.area_exited.connect(body_exited_wiper_area_x.bind(i))

func _physics_process(delta):
	for disk in disks:
		disk.wiper.rotate(Vector3.UP, deg_to_rad(rotation_speed_deg * delta))
	progress += rotation_speed_deg * delta
	if progress > 360.0:
		curr_start_id = (curr_start_id + 1) % disks.size()
		progress -= 360.0
	var mat = disks[0].progress_shader.mesh.surface_get_material(0)
	mat.set("shader_parameter/fill_amount", progress / 360.0)
	mat.set("shader_parameter/color2", colors[curr_start_id])
	mat.set("shader_parameter/color1", colors[(curr_start_id + 1) % disk_count])
	update_dissolve_shader_parameters()

func get_all_child_meshes(node: Node3D) -> Array[MeshInstance3D]:
	var result: Array[MeshInstance3D] = []
	var stack: Array[Node] = [node]
	while not stack.is_empty():
		var curr = stack.pop_front()
		if curr is MeshInstance3D:
			result.append(curr)
		stack.append_array(curr.get_children())
	return result


func update_dissolve_shader_parameters() -> void:
	for body in objects_being_wiped:
		var meshes = get_all_child_meshes(body)
		for mesh_instance in meshes:
			for mat_i in mesh_instance.mesh.get_surface_count():
				var mat = mesh_instance.mesh.surface_get_material(mat_i)
				mat.set("shader_parameter/intersector_pos", objects_being_wiped[body].global_position)
				mat.set("shader_parameter/intersector_radius", 40)

func set_wipeable_bodies_color() -> void:
	for disk_id in range(disks.size()):
		for body in find_all_wipeable_bodies(disks[disk_id]):
			for mesh_instance in get_all_child_meshes(body):
				mesh_instance.mesh.surface_get_material(0).set("shader_parameter/surface_albedo", object_colors[disk_id])
			pass


func find_all_wipeable_bodies(root_node: Node) -> Array[Node]:
	var result_arr: Array[Node] = []
	var stack: Array[Node] = []
	stack.append(root_node)
	while not stack.is_empty():
		var curr_node = stack.pop_front()
		if curr_node == null:
			continue
		for child in curr_node.get_children():
			if child.is_in_group("wipeable"):
				result_arr.append(child)
			else:
				stack.append_array(child.get_children())
	return result_arr

func disable_dissolve_shader(mesh_instance: MeshInstance3D) -> void:
	var mat = mesh_instance.mesh.surface_get_material(0)
	mat.set("shader_parameter/intersector_pos", Vector3.DOWN * 100)
	mat.set("shader_parameter/intersector_radius", 0)

func move_node_to_disk(body: Node3D, disk_id: int) -> void:
	var temp_pos = body.position
	body.get_parent().remove_child(body)
	if disk_id > disk_count:
		push_warning("provided disk_id too high!")
	disks[(disk_id) % disk_count].add_child(body)
	body.position = temp_pos
	if body is RigidBody3D:
		body.freeze = false
		body.linear_velocity = Vector3.ZERO
	if disk_id == 0:
		body.show()
	else:
		body.hide()

func is_last_disk(disk_id: int) -> bool:
	return disk_id + 1 == disks.size()

func body_entered_on_wiper_area_x(body: Node3D, disk_id: int) -> void:
	if body.is_in_group("wipeable") and not body in objects_being_wiped:
		# check if disk before 0
		if disk_id == 1:
			objects_being_wiped[body] = disks[0].undissolve_indicator
			move_node_to_disk(body, 0)
		else:
			objects_being_wiped[body] = disks[disk_id].dissolve_indicator
			if disk_id == 0:
				SoundManager.playSound3D(SoundManager.SOUND.WIPER, body.global_position)
		if body is RigidBody3D:
			body.freeze = true
		# if disk_id + 1 == disk_count:
			# move_node_to_disk(body

func body_exited_wiper_area_x(body: Node3D, disk_id: int) -> void:
	if body in objects_being_wiped:
		if disk_id == 0:
			SoundManager.stop_wiper_sound()
		# check if disk before 0 -> should not trigger as all is already handled
		if disk_id == 1:
			return
		var meshes = get_all_child_meshes(body)
		for mesh in meshes:
			disable_dissolve_shader(mesh)
		# check if exit while dissolve of undissolve of disk 0 is used, this should not move the disk
		if objects_being_wiped[body] != disks[disk_id].undissolve_indicator:
			objects_being_wiped.erase(body)
			move_node_to_disk(body, (disk_id - 1) % disk_count)
		else:
			objects_being_wiped.erase(body)
			if body is RigidBody3D:
				body.freeze = false