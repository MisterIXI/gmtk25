extends Node3D


const SMOOTH_ROTATE_ANGLE : float = deg_to_rad(5)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	rotate_x(SMOOTH_ROTATE_ANGLE)
	rotate_y(SMOOTH_ROTATE_ANGLE)
	rotate_z(SMOOTH_ROTATE_ANGLE)
