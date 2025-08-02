extends RigidBody3D


func _physics_process(delta):
	var input_2d = Input.get_vector("ui_left", "ui_right", "ui_down", "ui_up")
	linear_velocity = Vector3(input_2d.x, 0, -input_2d.y) * 10