extends RigidBody3D
class_name Interacting_Item

@onready var interact_area : Area3D = $Interacting_Area
var _new_parent : Node3D  = null
var _is_holding :bool  =false
var _tempbuttons : Array[Node]
func _ready() -> void:
	interact_area.body_entered.connect(_on_body_entered)
	interact_area.body_exited.connect(_on_body_exited)
	_tempbuttons = get_tree().get_nodes_in_group("trigger")
## respawn
func _physics_process(_delta: float) -> void:
	if global_position.y < -250.0:
		global_position.y = 1

func _on_body_entered(_body : Node3D)->void:
	if _body.is_in_group("player") and !_is_holding:
		_new_parent = _body
		print("show interacting")
		#show interacting 3d Sprite
		get_tree().get_first_node_in_group("interact_manager").start_interacting_on_position(global_position, self)

func _on_area_entered(_body : Node3D) ->void:
	if _body.is_in_group("wiper"):
		get_tree().get_first_node_in_group("interact_manager").drop_by_wiper()
		var _temp_pos : Vector3 = global_position
		# set new parent drop
		get_parent().remove_child(self)
		_body.get_parent().add_child(self)
		drop_effect(_temp_pos)


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
	SoundManager.playSound3D(SoundManager.SOUND.DROP_CRATE, global_position)

	global_position = _drop_position + Vector3(0,0.5,0)
