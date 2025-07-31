extends Node3D
class_name Interacting_Item

@onready var interact_area : Area3D = $Interacting_Area
var _new_parent : Node3D  = null
func _ready() -> void:
	interact_area.body_entered.connect(_on_interact)

func _on_interact(_body : Node3D)->void:
	if _body.is_in_group("player"):
		_new_parent = _body
		#show interacting 3d Sprite
		get_tree().get_first_node_in_group("interact_manager").start_interacting_on_position(global_position, self)

func interact()->void:
	print("Interact")
	_set_new_parent()

func _set_new_parent() ->void:
	get_parent().remove_child(self)
	_new_parent.player_visual_node.hand.add_child(self)
	position =  Vector3.ZERO
