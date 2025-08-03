extends Node3D
class_name Interacting_Manager

@onready var _interact_sprite : Node3D = $ui_interact
#Private Variables
var _caller : Node3D  = null
# holding interactable
var _current_holding_object : Node3D = null
var _player : Node3D = null
# set player
func _ready() -> void:
	_player = get_tree().get_first_node_in_group("player")

# handle input only if _caller defined
func _unhandled_input(event):
	if event.is_action_pressed("interact"):
		if _caller != null:
			_on_input_cast_interact()
		elif _current_holding_object != null:
			#drop item if held
			_drop_interactable()

# set _calller and show interactable sprite
func start_interacting_on_position(_pos : Vector3, caller : Node3D) ->void:
	_interact_sprite.global_position = _pos
	_interact_sprite.show()

	_caller = caller

# hide interactable sprite
func stop_interacting_on_position() ->void:
	_interact_sprite.hide()
	_caller = null

func _on_input_cast_interact() ->void:
	_caller.interact()
	_interact_sprite.hide()
	_caller = null
## Check if holding and set new current interactable and apply it to hand left
func set_new_interactable(_node : Node3D) ->void:
	if _current_holding_object != null:
		## drop current holding interactable
		_drop_interactable()
	if _node:
		# apply new current holding interactable item
		_current_holding_object = _node
		#remove mother and add as child to hand left
		_current_holding_object.get_parent().remove_child(_current_holding_object)
		_player.player_visual_node.hand.add_child(_current_holding_object)
		#reset local position
		_current_holding_object.position =  Vector3.ZERO
	else: 
		print("Interacting_Manager Error:  Null Object _node -> on set_new_interactable")

## drop current holding interactable
func _drop_interactable() ->void:
	if _current_holding_object:
		#save position
		var _temp_pos :Vector3 = _current_holding_object.global_position
		# remove holding interactable from hand
		_current_holding_object.get_parent().remove_child(_current_holding_object)
		get_tree().get_first_node_in_group("interact_manager").add_child(_current_holding_object)
		_current_holding_object.drop_effect(_temp_pos)
		_current_holding_object = null
	else: 
		print("Interacting_Manager Error:  Null Object on _drop_interactable")
func drop_by_wiper() ->void:
	if _current_holding_object:
		_current_holding_object  =null

