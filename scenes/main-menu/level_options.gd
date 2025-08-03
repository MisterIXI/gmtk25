extends Control

# (FIX) Declare the signal so other nodes know it exists.
signal back_pressed

@onready var _grid_container :GridContainer = $CenterContainer/VBoxContainer/PanelContainer/GridContainer
@export var _packed_scene_button_base : PackedScene

func _on_back_button_pressed():
	# Instead of self.hide(), we now emit our custom signal.
	emit_signal("back_pressed")
func _ready() -> void:
	_create_level(LevelManager.level_nodes)


func _create_level(array_level_items : Array[PackedScene]) ->void:
	for i in range(array_level_items.size()):
		var _new_button = _packed_scene_button_base.instantiate() as Button
		_grid_container.add_child(_new_button)
		_new_button.text = "Level "+ str(i+1)
		_new_button.pressed.connect(LevelManager._start_new_scene.bind(array_level_items[i], i))
	
