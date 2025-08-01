extends Node3D

@onready var _trigger_area : Area3D = $Trigger_Area
@onready var trigger_button : MeshInstance3D = $Trigger_button/button

@export var _trigger_red_button_mat : StandardMaterial3D
@export var _trigger_green_button_mat : StandardMaterial3D

# Private Variables
var _is_active : bool = false
func _ready() -> void:
	_trigger_area.body_entered.connect(_on_body_entered)
	_trigger_area.body_exited.connect(_on_body_exited)

func _on_body_entered(_body : Node3D) ->void:
	if _body.is_in_group("player") or _body.is_in_group("interactable"):
		turn_button(true)
func _on_body_exited(_body :Node3D) ->void:
	if _body.is_in_group("player") or _body.is_in_group("interactable"):
		turn_button(false)
	
func turn_button(_value  : bool)->void:
	# switch active ! active
	_is_active =_value
	if _is_active:
		trigger_button.set_surface_override_material(0,_trigger_green_button_mat)
		# trigger signal to mother
	else:
		trigger_button.set_surface_override_material(0,_trigger_red_button_mat)
