extends Control

@onready var _animation_player : AnimationPlayer =$AnimationPlayer

func on_scene_change() ->void: 
	print("ANIMATION START")
	_animation_player.play("resolve")

	await LevelManager.level_changed
	#### NEUES GELERNT AWAIT X.SIGNAL
	print("animation_backwards")
	_animation_player.play_backwards("resolve")
##pause game effect 
func on_game_paused_effect() ->void:
	_animation_player.play("pause")
## resume game effect
func on_game_resume_effect() ->void:
	_animation_player.play("RESET")