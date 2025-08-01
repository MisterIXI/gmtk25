class_name TimeWiper
extends Node


@export var disks: Array[Disk]
## current wipe angle in rad
var wipe_angle: float = 0.0

var objects_being_wiped: Array[Node3D] = []

func _ready():
	print("disks: ", disks)

func initialize(disk_arr: Array[Disk]) -> void:
	disks = disk_arr
	for disk in disks:
		disk.wiper_area.body_entered.connect(body_entered_on_wiper_area_x.bind(disk.disk_id))
	pass
func _physics_process(delta):
	for disk in disks:
		disk.wiper_area.rotate(Vector3.UP, 1.0 * delta)
	pass


func body_entered_on_wiper_area_x(body: Node3D, disk_id: int) -> void:
	if body.is_in_group("wipeable"):
		objects_being_wiped.append(body)
		if body is RigidBody3D:
			body.freeze = true
	pass

func body_exited_wiper_area_x(body: Node3D, disk_id: int) -> void:
	if body in objects_being_wiped:
		objects_being_wiped.erase(body)
		var temp_pos = body.position
		disks[(disk_id + 1) % disks.size()].add_child(body)
		body.position = temp_pos
		if body is RigidBody3D:
			body.freeze = false
		pass
	pass