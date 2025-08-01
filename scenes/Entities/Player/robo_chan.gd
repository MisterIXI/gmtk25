extends CharacterBody3D
@onready var player_visual_node : Node3D = $robo_chan_model

const SPEED : float = 7.5
const JUMP_VELOCITY : float = 4.5
const ACCELERATION : float  = 10

# Private Variables
var _input_direction : Vector2  = Vector2.ZERO
var _next_direction : Vector3 = Vector3.ZERO
# holding interactable
var _current_holding_object : Node3D = null

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
	if _input_direction != Vector2.ZERO:
		player_visual_node.look_at(_next_direction*SPEED)
	#apply velocity and slide
	move_and_slide()

func set_new_interactable(_node : Node3D) ->void:
	if _current_holding_object != null:
		## drop current holding interactable
		# remove holding interactable from hand
		_current_holding_object.get_parent().remove_child(_current_holding_object)
		_current_holding_object.drop_effect()
	if _node:
		# apply new item
		_current_holding_object = _node
		#add as child to hand left
		_current_holding_object.get_parent().remove_child(_current_holding_object)
		player_visual_node.hand.add_child(_current_holding_object)
		#reset local position
		position =  Vector3.ZERO
