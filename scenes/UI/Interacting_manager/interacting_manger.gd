extends Node3D
class_name Interacting_Manager

@onready var _interact_sprite: Node3D = $ui_interact

#Private Variables
var _caller: Node3D = null
# holding interactable
var _current_holding_object: Node3D = null
var _player: Node3D = null

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
func start_interacting_on_position(_pos: Vector3, caller: Node3D) -> void:
	_interact_sprite.global_position = _pos
	_interact_sprite.show()

	_caller = caller

# hide interactable sprite
func stop_interacting_on_position() -> void:
	_interact_sprite.hide()
	_caller = null

func _on_input_cast_interact() -> void:
	_caller.interact()
	_interact_sprite.hide()
	_caller = null
## Check if holding and set new current interactable and apply it to hand left
func set_new_interactable(_node: Node3D) -> void:
	if _current_holding_object != null:
		## drop current holding interactable
		_drop_interactable()
	if _node:
		# apply new current holding interactable item
		_current_holding_object = _node
		_node.get_parent().remove_child(_node)
		_player.add_child(_node)
		var new_pos = _player.global_position + -_player.global_transform.basis.z * 3.0 + Vector3.UP
		if _node is RigidBody3D:
			for child in _node.get_children():
				if child is CollisionShape3D:
					child.set_deferred("disabled", true)
			PhysicsServer3D.body_set_state(
				_node.get_rid(),
				PhysicsServer3D.BODY_STATE_TRANSFORM,
				Transform3D.IDENTITY.translated(Vector3.ZERO),
			)
			_node.position = Vector3.ZERO
			_node.global_position = new_pos
			_node.freeze = true
			_node.linear_velocity = Vector3.ZERO
		else:
			_node.global_position = new_pos
		#remove mother and add as child to hand left
		# _current_holding_object.hide()
		# _current_holding_object.set_deferred("freeze", true)
		#_interacting_fake
		# get_tree().get_first_node_in_group("player").interacting_fake.show()
	else:
		print("Interacting_Manager Error:  Null Object _node -> on set_new_interactable")

## drop current holding interactable
func _drop_interactable() -> void:
	print(_current_holding_object)
	if _current_holding_object:
		var temp_pos = _current_holding_object.global_position
		#save position
		if _current_holding_object is RigidBody3D:
			_current_holding_object.freeze = false
			_player.remove_child(_current_holding_object)
			_player.get_parent().add_child(_current_holding_object)
			for child in _current_holding_object.get_children():
				if child is CollisionShape3D:
					child.set_deferred("disabled", false)
		else:
			_player.remove_child(_current_holding_object)
			_player.get_parent().add_child(_current_holding_object)
		# get_tree().get_first_node_in_group("player").interacting_fake.hide()
		_current_holding_object.global_position = temp_pos
		# var _temp_pos: Vector3 = get_tree().get_first_node_in_group("player").interacting_fake.global_position
		# remove holding interactable from hand
		# _current_holding_object.drop_effect(_temp_pos)
		# _current_holding_object.show()
		_current_holding_object._is_holding = false
		_current_holding_object = null
	else:
		print("Interacting_Manager Error:  Null Object on _drop_interactable")
