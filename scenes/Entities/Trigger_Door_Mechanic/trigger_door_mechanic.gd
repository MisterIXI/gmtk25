extends Node3D
class_name Interacting_Door_Mechanic

signal is_activated(_value :bool)

## Contains all triggers from scene_tree, gets is_active
@export var trigger_collection : Array[Trigger_Button]

@onready var _animation_player : AnimationPlayer = $AnimationPlayer
#Private Variable
var _door_is_activated :bool = false
var _trigger_stats : Array[bool]

func _ready() -> void:
	#SET ALL TRIGGER VARS TO FALSE
	for x in trigger_collection:
		_trigger_stats.append(false)
		x.triggered.connect(_on_trigger_state_changed)

func _on_trigger_state_changed(_value : bool, trigger : Node3D)->void:
	# Set new trigger state on/off
	_trigger_stats[trigger_collection.find(trigger)] = _value

	# print("Trigger Set Index:",trigger_collection.find(trigger))
	# print("Value:", _value)
	
	# set to false if any button not longer pressed
	if !_check_triggers() and _door_is_activated:
		_switch_door_state(false)
	# set to true if all buttons where pressed
	elif _check_triggers() and !_door_is_activated:
		_switch_door_state(true)
	
func deactivate() ->void:
	_door_is_activated = false
	print("Disable Door")
	#animation
	_animation_player.play("activate_red")

func activate()->void:
	_door_is_activated = true
	print("Activate Door")
	#animation
	_animation_player.play("activate_both")

func _check_triggers() ->bool:
	var _temp :int = 0
	for x in _trigger_stats:
		if x:
			_temp += 1
	if _temp >= _trigger_stats.size():
		return true
	return false

func _switch_door_state(_value :bool) ->void:
	_door_is_activated = _value
	is_activated.emit(_value)
	if _door_is_activated:
		activate()
	else: 
		deactivate()


	
