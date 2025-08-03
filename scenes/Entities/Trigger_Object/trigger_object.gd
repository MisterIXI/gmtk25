extends Node3D
class_name Trigger_Button
### if Trigger changed state
signal activation_state_changed(_value : bool)
const ANIMATION_DURATION: float = 0.3
@onready var _trigger_area : Area3D = $Trigger_Area
@onready var trigger_button : MeshInstance3D = $ButtonTopMesh
# @onready var _animation_player :AnimationPlayer = $AnimationPlayer
# Private Variables
var tween: Tween = null

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
	# activation_state_changed.emit(_is_active, self)
	activation_state_changed.emit(_is_active)

	var mat = trigger_button.mesh.surface_get_material(0)
	if _is_active:
		# _animation_player.play("Pressed")
		# trigger signal to mother
		if tween != null:
			tween.kill()
		tween = create_tween()
		tween.tween_property(trigger_button, "position:y", 0,ANIMATION_DURATION)
		tween.tween_callback(func():
			mat.set("shader_parameter/surface_albedo", Color(0, 255, 0))
			mat.set("shader_parameter/emission", Color(0, 170, 0))
		)
	else:
		# _animation_player.play("unpressed")
		if tween != null:
			tween.kill()
		tween = create_tween()
		tween.tween_property(trigger_button, "position:y", 0.5,ANIMATION_DURATION)
		tween.tween_callback(func():
			mat.set("shader_parameter/surface_albedo", Color(255, 0, 0))
			mat.set("shader_parameter/emission", Color(0, 0, 0))
		)

