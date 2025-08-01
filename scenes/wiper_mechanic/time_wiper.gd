class_name TimeWiper
extends Node

@export var rotation_speed_deg: float = 60.0
@export var disks: Array[Disk]
## current wipe angle in rad
@export var colors: Array[Color]
var progress: float
var curr_start_id: int = 0
var wipe_angle: float = 0.0

var objects_being_wiped: Array[Node3D] = []

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
	mat.set("shader_parameter/color1", colors[(curr_start_id + 1) % disks.size()])
	pass


func body_entered_on_wiper_area_x(body: Node3D, disk_id: int) -> void:
	print("test")
	if body.is_in_group("wipeable"):
		objects_being_wiped.append(body)
		if body is RigidBody3D:
			body.freeze = true

		print("Wiping body: ", body.name)
	pass

func body_exited_wiper_area_x(body: Node3D, disk_id: int) -> void:
	if body in objects_being_wiped:
		objects_being_wiped.erase(body)
		var temp_pos = body.position
		body.get_parent().remove_child(body)
		disks[(disk_id + 1) % disks.size()].add_child(body)
		body.position = temp_pos
		if body is RigidBody3D:
			body.freeze = false
		pass
		print("Body \"", body.name, "\" has exited")
	pass