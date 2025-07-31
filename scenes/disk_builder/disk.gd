class_name Disk
extends Node3D

var disk_id: int = -1

@export var disk_collision_shape: CollisionShape3D
@export var disk_mesh: MeshInstance3D
@export var wiper_area: Area3D
@export var wiper_col_shape: CollisionShape3D
@export var wiper_mesh: MeshInstance3D