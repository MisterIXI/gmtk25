extends Node3D
class_name Portal_Level_Mechanic

# this script check if trigger is on and switch materials
# if player entered this area and trigger all on- 
#animation will play and level is finished
@export var _door_mechanic : Interacting_Door_Mechanic
@export var _portal_active_area_mat : StandardMaterial3D
@export var _portal_active_bogen_mat : StandardMaterial3D
@export var _portal_mesh : MeshInstance3D
## base mats
#Private Variables
var _base_portal_active_area_mat : StandardMaterial3D
var _base_portal_active_bogen_mat : StandardMaterial3D
@export var portal_is_enabled : bool = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	_door_mechanic.is_activated.connect(_on_door_mechanic_changed)
	_base_portal_active_area_mat = _portal_mesh.mesh.surface_get_material(1)
	_base_portal_active_bogen_mat = _portal_mesh.mesh.surface_get_material(2)
	#set door active or deactive
	_on_door_mechanic_changed(portal_is_enabled)

func _on_door_mechanic_changed(_value : bool)->void:
	if _value:
		_turn_on_portal()
	else:
		_turn_off_portal()

func _turn_on_portal() ->void:
	print("portal is open")
	portal_is_enabled = true
	_portal_mesh.mesh.surface_set_material(1,_portal_active_area_mat)
	_portal_mesh.mesh.surface_set_material(2,_portal_active_bogen_mat)

func _turn_off_portal() ->void:
	print("portal closed")
	portal_is_enabled = false
	_portal_mesh.mesh.surface_set_material(1,_base_portal_active_area_mat)
	_portal_mesh.mesh.surface_set_material(2,_base_portal_active_bogen_mat)



func _on_finish_area_body_entered(_body: Node3D) -> void:
	if _body.is_in_group("player") and portal_is_enabled:
		print("Player finished")
		# particle
		_body.enable_particles()
		#tween to move up
		var tween = create_tween()

		tween.tween_property(_body, "position", Vector3(0, 100,0), 5)
		tween.set_ease(Tween.EASE_IN)
		## SIGNAL LEVEL FINISHED

