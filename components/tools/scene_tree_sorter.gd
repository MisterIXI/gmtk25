@tool
class_name SceneTreeSorter
extends Node

@export_tool_button("Sort children") var sort_button = sort_children

func sort_children() -> void:
	var children = get_children()
	children.sort_custom(func(a, b): return a.name.naturalcasecmp_to(b.name) < 0)
	# apply new order
	for child in children:
		remove_child(child)
	for child in children:
		add_child(child)
		child.owner = get_tree().edited_scene_root
	print("Sorted my children!")