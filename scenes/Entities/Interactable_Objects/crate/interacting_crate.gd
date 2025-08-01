extends Node3D
class_name Interacting_Item

@onready var interact_area : Area3D = $Interacting_Area
var _new_parent : Node3D  = null
func _ready() -> void:
	interact_area.body_entered.connect(_on_body_entered)

func _on_body_entered(_body : Node3D)->void:
	if _body.is_in_group("player"):
		_new_parent = _body
		print("show interacting")
		#show interacting 3d Sprite
		get_tree().get_first_node_in_group("interact_manager").start_interacting_on_position(global_position, self)

func _on_body_exited(_body : Node3D) -> void:
	if _body.is_in_group("player"):
		_new_parent = null
		print("hide interacting")
		#hide interacting 3d Sprite
		get_tree().get_first_node_in_group("interact_manager").stop_interacting_on_position()
	
func interact()->void:
	print("Interact")
	get_tree().get_first_node_in_group("player").set_new_interactable(self)

func drop_effect() ->void:
	print("drop")
	var tween = create_tween()
	tween.tween_property(self, "position:y",0.5, 1.5)
	tween.tween_property(self, "position:y", 0.5, 1.5)
	