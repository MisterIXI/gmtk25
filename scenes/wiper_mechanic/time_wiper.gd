class_name TimeWiper
extends Node

@export var rotation_speed_deg: float = 30.0
@export var disks: Array[Disk]
## current wipe angle in rad
@export var colors: Array[Color]
var progress: float
var curr_start_id: int = 0
var wipe_angle: float = 0.0

var objects_being_wiped: Dictionary[Node3D, MeshInstance3D] = {}
@onready var disk_count: int = disks.size()
func _ready():
	for i in range(disks.size()):
		disks[i].wiper.body_entered.connect(body_entered_on_wiper_area_x.bind(i))
		disks[i].wiper.body_exited.connect(body_exited_wiper_area_x.bind(i))

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
			var mat = mesh_instance.mesh.surface_get_material(0)
			mat.set("shader_parameter/intersector_pos", objects_being_wiped[body].global_position)
			mat.set("shader_parameter/intersector_radius", 40)

func disable_dissolve_shader(mesh_instance: MeshInstance3D) -> void:
	var mat = mesh_instance.mesh.surface_get_material(0)
	mat.set("shader_parameter/intersector_pos", Vector3.ZERO)
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

func next_disk(disk_id: int) -> int:
	return (disk_id + 1) % disks.size()

func body_entered_on_wiper_area_x(body: Node3D, disk_id: int) -> void:
	if body.is_in_group("wipeable") and not body in objects_being_wiped:
		if is_last_disk(disk_id):
			objects_being_wiped[body] = disks[0].undissolve_indicator
			move_node_to_disk(body, 0)
		else:
			objects_being_wiped[body] = disks[disk_id].dissolve_indicator
		if body is RigidBody3D:
			body.freeze = true
		# if disk_id + 1 == disk_count:
			# move_node_to_disk(body

func body_exited_wiper_area_x(body: Node3D, disk_id: int) -> void:
	if body in objects_being_wiped:
		# check if last disk -> should not trigger as all is already handled
		if is_last_disk(disk_id):
			return
		var meshes = get_all_child_meshes(body)
		for mesh in meshes:
			disable_dissolve_shader(mesh)
		# check if exit while dissolve of undissolve of disk 0 is used, this should not move the disk
		if objects_being_wiped[body] != disks[disk_id].undissolve_indicator:
			objects_being_wiped.erase(body)
			move_node_to_disk(body, (disk_id + 1) % disk_count)
		else:
			objects_being_wiped.erase(body)
			if body is RigidBody3D:
				body.freeze = false