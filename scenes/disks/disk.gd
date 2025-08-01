class_name Disk
extends Node3D


@export_range(0,10) var disk_id: int

@export var wiper: Area3D
@export var progress_shader: MeshInstance3D
@export var dissolve_indicator: MeshInstance3D
@export var undissolve_indicator: MeshInstance3D