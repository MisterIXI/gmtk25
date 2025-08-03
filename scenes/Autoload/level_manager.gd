extends Node
#Here we pack all level in the inspector
@export var level_nodes : Array[PackedScene]
@export var menu_scene: PackedScene
var level_beaten_status: Array[bool]

signal level_changed()
#private variables 
var current_scene = null
var current_index : int = -1
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	for i in range(level_nodes.size()):
		level_beaten_status.append(false)
	pass # Replace with function body.


func _input(event):
	if event is InputEventKey:
		if event.is_pressed() and event.keycode == KEY_R:
			reload_current_scene()

### this function will switch in level selection scene
func on_level_change(index : int) ->void:
	if index >= level_nodes.size():
		go_to_menu()
	else:
		call_deferred("_start_new_scene",level_nodes[index], index)
		current_index = index

func on_start_game() ->void:
	call_deferred("_start_new_scene",level_nodes[0], 0)
	current_index = 0
	
### this function will switch in continues gaming after using the portal
func on_next_level_change() ->void:

	if current_index != -1:
		level_beaten_status[current_index] = true
		Mainmenu.update_level_beaten_states(level_beaten_status)
		on_level_change(current_index + 1)
	else:
		go_to_menu()
	# if current_scene == null:
	# 	go_to_menu()
	# else:
	# 	current_index += 1
	# 	call_deferred("_start_new_scene",level_nodes[current_index])

func go_to_menu() -> void:
	get_tree().change_scene_to_packed.call_deferred(menu_scene)
	current_scene = null

func _start_new_scene(_scene : PackedScene, id: int = -1) ->void:
	current_index = id
	Mainmenu.close_menu()
	print("Start Next Level")
	get_tree().change_scene_to_packed.call_deferred(_scene)
	current_scene = get_tree().current_scene
	level_changed.emit()

func reload_current_scene() -> void:
	get_tree().reload_current_scene.call_deferred()