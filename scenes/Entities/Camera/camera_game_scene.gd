extends Camera3D
const BASE_CAMERA_SMOOTH :float = 1.5
const BASE_CAMERA_ZOOM_SPEED:  float =5
const MIN_MAX_ZOOM :Vector2  = Vector2(-20.0,50.0)

var _current_zoom : float = 0

func _input(_event: InputEvent) -> void:
	if Input.is_action_just_pressed("zoom_in"):
		_current_zoom += 1
		if _current_zoom > MIN_MAX_ZOOM.y:
			_current_zoom = MIN_MAX_ZOOM.y
			#Sound MAX ZOOM 
		else:
			_zoom_in()	
	if Input.is_action_just_pressed("zoom_out"):
		_current_zoom-= 1
		if _current_zoom <MIN_MAX_ZOOM.x:
			_current_zoom = MIN_MAX_ZOOM.x
			#SOUND MIN ZOOM
		else:
			_zoom_out()



func _zoom_in():
	var _new_pos :Vector3 = Vector3(global_position.x,
	global_position.y -BASE_CAMERA_ZOOM_SPEED,
	global_position.z -BASE_CAMERA_ZOOM_SPEED/2)
	var tween = create_tween()
	tween.tween_property(self, "global_position", _new_pos, BASE_CAMERA_SMOOTH)

func _zoom_out():
	var _new_pos :Vector3 = Vector3(global_position.x,
	global_position.y +BASE_CAMERA_ZOOM_SPEED,
	global_position.z +BASE_CAMERA_ZOOM_SPEED/2)
	var tween = create_tween()
	tween.tween_property(self, "global_position", _new_pos, BASE_CAMERA_SMOOTH)