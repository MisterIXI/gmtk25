extends CharacterBody3D
@onready var player_visual_node : Node3D = $robo_chan_model

const SPEED : float = 7.5
const JUMP_VELOCITY : float = 4.5
const ACCELERATION : float  = 10
const LOOK_SMOOTHNESS : float = 8.0
# Private Variables
var _input_direction : Vector2  = Vector2.ZERO
var _next_direction : Vector3 = Vector3.ZERO
# holding interactable
var _current_holding_object : Node3D = null

################## INPUT HANDLE
func _unhandled_input(event):
	if event.is_action_pressed("interact"):
		if _current_holding_object != null:
			#drop item if held
			_drop_interactable()

################### PHYSIC PROCESS 
func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta

	# Handle jump.
	if Input.is_action_just_pressed("jump") and is_on_floor():
		#case if nearby object else jump
		velocity.y = JUMP_VELOCITY

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	_input_direction = Input.get_vector("move_left", "move_right", "move_up", "move_down")
	# calculate input direction from Characterbody3D
	_next_direction = (transform.basis * Vector3(_input_direction.x, 0,_input_direction.y)).normalized()
	# if any input
	if _next_direction:
		velocity.x = move_toward(velocity.x, _next_direction.x * SPEED, ACCELERATION)
		velocity.z =move_toward(velocity.z, _next_direction.z * SPEED, ACCELERATION)
	else:
		# lerp to Zero
		velocity.x = move_toward(velocity.x, 0, SPEED)
		velocity.z = move_toward(velocity.z, 0, SPEED)
	#apply visual to look to direction
	if _next_direction.length() > 0.1:
		#TODO
		# var _temp_trans  = global_transform.looking_at(player_visual_node.global_position + Vector3(_input_direction.x,0,_input_direction.y),Vector3.UP)
		# rotation = rotate_toward(global_transform.basis., _temp_trans.basis,delta * 1.2)
		player_visual_node.look_at(player_visual_node.global_position + Vector3(_input_direction.x,0,_input_direction.y), Vector3(0, 1, 0))
	#apply velocity and slide
	move_and_slide()

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
		player_visual_node.hand.add_child(_current_holding_object)
		#reset local position
		_current_holding_object.position =  Vector3.ZERO
	else: 
		print("Player_Controller Error:  Null Object _node -> on set_new_interactable")

## drop current holding interactable
func _drop_interactable() ->void:
	if _current_holding_object:
		#save position
		var _temp_pos :Vector3 = _current_holding_object.global_position
		# remove holding interactable from hand
		_current_holding_object.get_parent().remove_child(_current_holding_object)
		get_tree().get_first_node_in_group("interact_manager").add_child(_current_holding_object)
		_current_holding_object.drop_effect(_temp_pos)
	else: 
		print("Player_Controller Error:  Null Object on _drop_interactable")
