@tool
class_name DiskBuilder
extends Node3D

@export var disk_preset: PackedScene
@export var disk_setting: DiskSettings
@export_range(1, 10) var disk_count: int = 3
@export_range(180, 360) var deg_max: float = 360

@export_tool_button("Regenerate disks", "Node3D") var regen_button = regenerate_disks
@export_tool_button("Delete disks", "StatusError") var delete_button = delete_spawned_disks

@onready var parent: Node3D = get_parent()

var spawned_disks: Array[Disk] = []
var time_wiper: TimeWiper = null

func _ready():
	if not Engine.is_editor_hint():
		queue_free()

func regenerate_disks() -> void:
	# time wiper node
	find_time_wiper()
	if time_wiper:
		time_wiper.queue_free()
	time_wiper = TimeWiper.new()
	time_wiper.name = "TimeWiper"
	parent.add_child(time_wiper)
	time_wiper.owner = get_tree().edited_scene_root
	# disks
	for i in range(disk_count):
		var disk = disk_preset.instantiate() as Disk
		parent.add_child(disk)
		disk.name = "Disk" + str(i)
		disk.set("disk_id", i)
		# parent.set_editable_instance(disk, true)
		disk.global_position = Vector3.RIGHT * i * (disk_setting.disk_radius * 2 + 5.0)
		spawned_disks.append(disk)
		disk.disk_collision_shape.shape.radius = disk_setting.disk_radius
		disk.disk_mesh.mesh.top_radius = disk_setting.disk_radius
		disk.disk_mesh.mesh.bottom_radius = disk_setting.disk_radius
		disk.disk_mesh.mesh.surface_set_material(0, disk_setting.disk_mat)
		disk.owner = get_tree().edited_scene_root
		# set_owner_recursive(disk, get_tree().edited_scene_root)
		# wiper
		disk.wiper_mesh.mesh.size = Vector3(disk_setting.disk_radius, 2.0, 0.5)
		disk.wiper_mesh.position = Vector3(disk_setting.disk_radius / 2.0, 1.0, 0)
		disk.wiper_mesh.mesh.surface_set_material(0, disk_setting.wiper_mat)
		disk.wiper_col_shape.shape.size = Vector3(disk_setting.disk_radius, 2.0, 0.5)
		disk.wiper_col_shape.position = Vector3(disk_setting.disk_radius / 2.0, 1.0, 0)
		# EditorInterface.save_scene()
		# parent.set_editable_instance(disk, false)
	# set disk array to time wiper
	# time_wiper.set_deferred("disks", spawned_disks.duplicate())
	# time_wiper.initialize(spawned_disks.duplicate())
	EditorInterface.mark_scene_as_unsaved()

func find_time_wiper() -> void:
	if time_wiper == null:
		for child in get_tree().edited_scene_root.get_children():
			if child is TimeWiper:
				time_wiper = child
				break

func delete_spawned_disks() -> void:
	if spawned_disks == null:
		push_warning("Spawned_disks is null, aborting....")
		spawned_disks = []
		return
	elif spawned_disks.is_empty():
		for child in get_tree().edited_scene_root.get_children():
			if child is Disk:
				spawned_disks.append(child)
	for disk in spawned_disks:
		disk.queue_free()
	spawned_disks.clear()
	find_time_wiper()
	if time_wiper:
		time_wiper.queue_free()

func set_owner_recursive(node: Node, node_owner: Node) -> void:
	node.owner = node_owner
	for child in node.get_children():
		set_owner_recursive(child, node)