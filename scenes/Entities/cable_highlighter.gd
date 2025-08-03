class_name CableHighlighter
extends Node
@export var cable_arr: Array[Area3D] = []

@export var trigger_object: Trigger_Button
@export var color_active: Color = Color(0, 1, 0)
@export var color_inactive: Color = Color(1, 0, 0)
@export var anim_delay: float = 0.01
@export var start_active: bool = false

signal activation_state_changed(new_state: bool)


func _ready():
	light_up(start_active)
	trigger_object.activation_state_changed.connect(light_up)
	pass


func light_up(is_positive: bool) -> void:
	if not is_inside_tree():
		# print("Waiting for tree!")
		await tree_entered
	for i in range(cable_arr.size()):
		for child in cable_arr[i].get_children():
			if child is MeshInstance3D:
				var mat = child.mesh.surface_get_material(0)
				if is_positive:
					mat.set("shader_parameter/surface_albedo", color_active)
					mat.set("shader_parameter/emission", color_active/2.0)
				else:
					mat.set("shader_parameter/surface_albedo", color_inactive)
					mat.set("shader_parameter/emission", color_inactive/2.0)
		await get_tree().create_timer(anim_delay).timeout
	activation_state_changed.emit(is_positive)
	pass