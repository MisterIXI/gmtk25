@tool
extends Node3D

@export var material:ShaderMaterial

func _process(_delta: float) -> void:
	material.set_shader_parameter("intersector_pos", global_position)
	material.set_shader_parameter("intersector_radius", 0.5 * scale.x)