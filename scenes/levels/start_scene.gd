extends Node3D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	LevelManager.on_start_game()