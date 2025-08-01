extends Node3D
class_name Interacting_Item

@onready var interact_area : Area3D = $Interacting_Area
var _new_parent : Node3D  = null
var _is_holding :bool  =false
var _tempbuttons : Array[Node]
func _ready() -> void:
	interact_area.body_entered.connect(_on_body_entered)
	interact_area.body_exited.connect(_on_body_exited)
	_tempbuttons = get_tree().get_nodes_in_group("trigger")

func _on_body_entered(_body : Node3D)->void:
	if _body.is_in_group("player") and !_is_holding:
		_new_parent = _body
		print("show interacting")
		#show interacting 3d Sprite
		get_tree().get_first_node_in_group("interact_manager").start_interacting_on_position(global_position, self)

func _on_body_exited(_body : Node3D) -> void:
	if _body.is_in_group("player")and !_is_holding:
		_new_parent = null
		print("hide interacting")
		#hide interacting 3d Sprite
		get_tree().get_first_node_in_group("interact_manager").stop_interacting_on_position()
	
func interact()->void:
	print("Interact")
	get_tree().get_first_node_in_group("interact_manager").set_new_interactable(self)
	_is_holding = true

func drop_effect(_drop_position : Vector3) ->void:
	print("drop")
	_is_holding = false
	#check if button is nearby
	var _result : bool = false
	for x in _tempbuttons:
		if x.global_position.distance_to(global_position)< 3:
		#set interactable position to button
			print("fixed crate position")
			global_position = x.global_position
			_result = true
		else:
			_result = false

	if !_result:
		global_position = _drop_position + Vector3(0,0.5,0)
