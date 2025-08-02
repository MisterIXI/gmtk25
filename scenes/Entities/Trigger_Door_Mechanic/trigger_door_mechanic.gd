extends Node3D
class_name Interacting_Door_Mechanic
## Contains all triggers from scene_tree, gets is_active
@export var trigger_collection : Array[Trigger_Button]

@onready var interact_area : Area3D = $Interacting_Area
@onready var _animation_player : AnimationPlayer = $AnimationPlayer
#Private Variable
var _door_is_activated :bool = false
var _trigger_stats : Array[bool]

func _ready() -> void:
	interact_area.body_entered.connect(_on_body_entered)

	#SET ALL TRIGGER VARS TO FALSE
	for x in trigger_collection:
		_trigger_stats.append(false)
		x.triggered.connect(_on_trigger_state_changed)

func _on_trigger_state_changed(_value : bool, trigger : Node3D)->void:
	# Set new trigger state on/off
	_trigger_stats[trigger_collection.find(trigger)] = _value

	print("Trigger Set Index:",trigger_collection.find(trigger))
	print("Value:", _value)
	if !_check_triggers() and _door_is_activated:
		_switch_door_state_off()

func _on_body_entered(_body : Node3D)->void:
	if _body.is_in_group("player"):
		#highlight
		activate()
func _on_body_exited(_body : Node3D)->void:
	if _body.is_in_group("player"):
		#highlight
		_animation_player.play("highlight")
		deactivate()
	
func deactivate() ->void:
	if _door_is_activated:
		_check_triggers()

func activate()->void:
	if _check_triggers() and !_door_is_activated:
		_door_is_activated = true
		print("Activate Door")
		#animation
		_animation_player.play("activate_both")
	else: 
		if !_door_is_activated:
			_switch_door_state_off()

func _check_triggers() ->bool:
	var _temp :int = 0
	for x in _trigger_stats:
		if x:
			_temp += 1
	if _temp >= _trigger_stats.size():
		return true
	return false

func _switch_door_state_off() ->void:
	_door_is_activated = false
	print("Disable Door")
	#animation
	_animation_player.play("activate_red")

	
