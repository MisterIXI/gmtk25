extends Node
#Here we pack all level in the inspector
@export var level_nodes : Array[PackedScene]

signal level_changed()
#private variables 
var current_scene = null
var current_index : int = 0
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

### this function will switch in level selection scene
func on_level_change(index : int) ->void:

	call_deferred("_start_new_scene",level_nodes[index])
	current_index = index

func on_start_game() ->void:
	call_deferred("_start_new_scene",level_nodes[0])
	
### this function will switch in continues gaming after using the portal
func on_next_level_change() ->void:
	current_index += 1
	call_deferred("_start_new_scene",level_nodes[current_index])


func _start_new_scene(_scene : PackedScene) ->void:
	Mainmenu.close_menu()
	print("Start Next Level")
	if current_scene != null:
		current_scene.free()  # Free the current scene if it exists
	current_scene = _scene.instantiate()
	get_tree().root.add_child(current_scene)  # Add the new scene to the root
	get_tree().current_scene = current_scene  # Set the current scene in the tree
	level_changed.emit()
