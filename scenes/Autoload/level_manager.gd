extends Node
#Here we pack all level in the inspector
@export var level_nodes : Array[PackedScene]
@export var menu_scene: PackedScene

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
	if current_scene == null:
		go_to_menu()
	else:
		current_index += 1
		call_deferred("_start_new_scene",level_nodes[current_index])

func go_to_menu() -> void:
	get_tree().change_scene_to_packed.call_deferred(menu_scene)
	current_scene = null

func _start_new_scene(_scene : PackedScene) ->void:
	Mainmenu.close_menu()
	print("Start Next Level")
	get_tree().change_scene_to_packed.call_deferred(_scene)
	current_scene = get_tree().current_scene
	level_changed.emit()
