extends Node3D


@onready var _interact_sprite : Node3D = $ui_inteacting
#Private Variables
var _caller : Node3D  = null

# handle input only if _caller defined
func _unhandled_input(event):
	if event.is_action_pressed("interact"):
		if _caller != null:
			_on_input_cast_interact()

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
