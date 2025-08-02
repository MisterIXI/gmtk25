extends WorldEnvironment

var SMOOTH_ROTATION :float = 0.001
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	environment.sky_rotation.x += SMOOTH_ROTATION * delta
