extends Camera3D

@export var target: Node3D
@export var distance := 10.0
@export var min_distance := 2.0
@export var max_distance := 50.0
@export var zoom_speed := 2.0

@export var rotation_speed := 0.01
@export var move_speed := 5.0
@export var vertical_limit := 1.5  # Limit for vertical _rotation (radians)

var _rotation := Vector2(0.0, 0.0)  # x: yaw, y: pitch
var dragging := false

var camera :=  self

func _ready():
    Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
    if target:
        var to_target = (global_position - target.global_position).normalized()
        _rotation.x = atan2(to_target.x, to_target.z)
        _rotation.y = asin(to_target.y)
        update_camera_position()

func _unhandled_input(event):
    if event is InputEventMouseButton:
        if event.button_index == MOUSE_BUTTON_RIGHT:
            dragging = event.pressed
            Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

        elif event.button_index == MOUSE_BUTTON_WHEEL_UP:
            distance = max(min_distance, distance - zoom_speed)
        elif event.button_index == MOUSE_BUTTON_WHEEL_DOWN:
            distance = min(max_distance, distance + zoom_speed)

    elif event is InputEventMouseMotion and dragging:
        _rotation.x -= event.relative.x * rotation_speed
        _rotation.y = clamp(_rotation.y - event.relative.y * rotation_speed, -vertical_limit, vertical_limit)

func _physics_process(delta):
    handle_movement(delta)
    update_camera_position()

func handle_movement(delta):
    if not target:
        return

    var input_vector = Vector3.ZERO

    if Input.is_action_pressed("move_up"):
        input_vector.z -= 1
    if Input.is_action_pressed("move_down"):
        input_vector.z += 1
    if Input.is_action_pressed("move_left"):
        input_vector.x -= 1
    if Input.is_action_pressed("move_right"):
        input_vector.x += 1

    if input_vector != Vector3.ZERO:
        input_vector = input_vector.normalized()
        var transform = Transform3D(Basis(Vector3.UP, _rotation.x), Vector3.ZERO)
        var direction = transform.basis * input_vector
        target.global_position += direction * move_speed * delta

func update_camera_position():
    if not target:
        return

    var offset = Vector3(
        distance * cos(_rotation.y) * sin(_rotation.x),
        distance * sin(_rotation.y),
        distance * cos(_rotation.y) * cos(_rotation.x)
    )

    global_position = target.global_position + offset
    look_at(target.global_position, Vector3.UP)