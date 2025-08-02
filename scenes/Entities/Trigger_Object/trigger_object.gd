extends Node3D
class_name Trigger_Button
### if Trigger changed state
signal triggered(_value : bool)

@onready var _trigger_area : Area3D = $Trigger_Area
@onready var trigger_button : MeshInstance3D = $Trigger_button/button
@onready var _animation_player :AnimationPlayer = $AnimationPlayer

# Private Variables
var _is_active : bool = false
func _ready() -> void:
	_trigger_area.body_entered.connect(_on_body_entered)
	_trigger_area.body_exited.connect(_on_body_exited)
# if entity entered the area
func _on_body_entered(_body : Node3D) ->void:
	if _body.is_in_group("player") or _body.is_in_group("interactable"):
		turn_button(true)

func _on_body_exited(_body :Node3D) ->void:
	if _body.is_in_group("player") or _body.is_in_group("interactable"):
		turn_button(false)
	
func turn_button(_value  : bool)->void:
	# switch active ! active
	_is_active =_value

	# cast signal to mother
	triggered.emit(_is_active, self)

	if _is_active:
		_animation_player.play("Pressed")
		# trigger signal to mother
	else:
		_animation_player.play("unpressed")
