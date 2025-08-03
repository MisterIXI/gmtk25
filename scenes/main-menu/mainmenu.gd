extends Control

@onready var main_menu_buttons = %MainMenuButtons
@onready var user_options = %UserOptions
@onready var level_options= %LevelOptions
@onready var menu_control : Control = $Menu
@onready var scene_transition_control: Control = $Level_Transition
@onready var _start_button : Button =$Menu/SlidingContainer/CenterStuff/MainMenuButtons/Button
@onready var _resume_button : Button  =$Menu/SlidingContainer/CenterStuff/MainMenuButtons/Button4

@export var menu_scene : PackedScene

var active_tween: Tween
var _is_game_paused: bool = false

# func _input(event: InputEvent) -> void:
# 	if event.is_action_pressed("escape") and !_is_game_paused:
# 		#Pause Game
# 		print("PAUSED GAME")
# 		#click sound
# 		SoundManager.playSound(SoundManager.SOUND.CLICK)
# 		_on_button_paused_game_pressed()

func _init():
	hide()

func _ready() -> void:
	#debugging brought to you by 
	#GEMINI :D
	if not main_menu_buttons:
		main_menu_buttons = get_node_or_null("MainMenuButtons")
		if not main_menu_buttons:
			push_error("MainMenuButtons node not found!")
			return

	if not user_options:
		user_options = get_node_or_null("UserOptions")
		if not user_options:
			push_error("UserOptions node not found!")
			return
		
	if user_options.has_signal("back_pressed"):
		user_options.back_pressed.connect(_on_user_options_back_pressed)
	else:
		push_error("UserOptions doesn't have back_pressed signal!")
	# LEVEL
	if level_options.has_signal("back_pressed"):
		level_options.back_pressed.connect(_on_level_options_back_pressed)
	else:
		push_error("UserOptions doesn't have back_pressed signal!")
	
	user_options.visible = false
	user_options.modulate.a = 0.0

func on_scene_change_cast_transition_effect()->void:
	scene_transition_control.on_scene_change()

#start game and hide menu - transition 
func _on_start_game_button_pressed() -> void:
	on_scene_change_cast_transition_effect()
	#hide start button and show resume
	_start_button.hide()
	_resume_button.show()
	#click sound
	SoundManager.playSound(SoundManager.SOUND.CLICK)
	menu_control.hide()
	LevelManager.on_start_game()

func _on_options_button_pressed() -> void:
	if not main_menu_buttons or not user_options:
		return

	if active_tween and active_tween.is_running():
		return

	active_tween = create_tween()

	active_tween.parallel().tween_property(self, "position", Vector2(-80, 0), 0.3).set_trans(Tween.TRANS_SINE)
	active_tween.parallel().tween_property(main_menu_buttons, "modulate:a", 0.0, 0.3)
	active_tween.tween_callback(_show_options_menu)
	active_tween.tween_property(user_options, "modulate:a", 1.0, 0.3)

	####### LEVEL SELECTION PRESSED
func _on_level_selection_button_pressed() -> void:
	if not main_menu_buttons or not level_options:
		return

	if active_tween and active_tween.is_running():
		return

	active_tween = create_tween()

	active_tween.parallel().tween_property(self, "position", Vector2(-80, 0), 0.3).set_trans(Tween.TRANS_SINE)
	active_tween.parallel().tween_property(main_menu_buttons, "modulate:a", 0.0, 0.3)
	active_tween.tween_callback(_show_level_menu)
	active_tween.tween_property(level_options, "modulate:a", 1.0, 0.3)


func _on_level_options_back_pressed() ->void:
	if not main_menu_buttons or not user_options:
		return

	if active_tween and active_tween.is_running():
		return
	active_tween = create_tween()

	active_tween.tween_property(level_options, "modulate:a", 0.0, 0.3)
	active_tween.tween_callback(_show_main_menu)

	active_tween.parallel().tween_property(self, "position", Vector2.ZERO, 0.3).set_trans(Tween.TRANS_SINE)
	active_tween.parallel().tween_property(main_menu_buttons, "modulate:a", 1.0, 0.3)

func _on_user_options_back_pressed() -> void:
	if not main_menu_buttons or not user_options:
		return

	if active_tween and active_tween.is_running():
		return

	active_tween = create_tween()

	active_tween.tween_property(user_options, "modulate:a", 0.0, 0.3)
	active_tween.tween_callback(_show_main_menu)

	active_tween.parallel().tween_property(self, "position", Vector2.ZERO, 0.3).set_trans(Tween.TRANS_SINE)
	active_tween.parallel().tween_property(main_menu_buttons, "modulate:a", 1.0, 0.3)

func _on_quit_button_pressed() -> void:
	#click sound
	SoundManager.playSound(SoundManager.SOUND.CLICK)
	get_tree().quit()
	
func _show_options_menu() -> void:
	if main_menu_buttons and is_instance_valid(main_menu_buttons):
		main_menu_buttons.visible = false
	if user_options and is_instance_valid(user_options):
		#click sound
		SoundManager.playSound(SoundManager.SOUND.CLICK)
		user_options.visible = true

#### SHOW LEVEL OPTION
func _show_level_menu() -> void:
	if main_menu_buttons and is_instance_valid(main_menu_buttons):
		main_menu_buttons.visible = false
	if level_options and is_instance_valid(level_options):
		#click sound
		SoundManager.playSound(SoundManager.SOUND.CLICK)
		level_options.visible = true

#thanks ai for showing me some stupid fixes. I dont know
func _show_main_menu() -> void:
	if user_options and is_instance_valid(user_options):
		user_options.visible = false
		level_options.visible = false
	if main_menu_buttons and is_instance_valid(main_menu_buttons):
		#click sound
		SoundManager.playSound(SoundManager.SOUND.CLICK)
		main_menu_buttons.visible = true

func _on_button_paused_game_pressed() ->void:
	get_tree().paused = true
	_is_game_paused = true
	scene_transition_control.on_game_paused_effect()
	user_options.visible = false
	level_options.visible = false
	menu_control.show()

func _on_button_resume_pressed() -> void:
	#click sound
	SoundManager.playSound(SoundManager.SOUND.CLICK)
	scene_transition_control.on_game_resume_effect()
	get_tree().paused = false
	_is_game_paused =false

	on_scene_change_cast_transition_effect()
	menu_control.hide()
	user_options.visible = false
	level_options.visible = false

func close_menu() ->void:
	on_scene_change_cast_transition_effect()
	menu_control.hide()
	user_options.visible = false
	level_options.visible = false
	_is_game_paused = false
	get_tree().paused = false
	#click sound
	SoundManager.playSound(SoundManager.SOUND.CLICK)

func open_menu() -> void:
	menu_control.show()
	user_options.visible = false
	level_options.visible = false
	_is_game_paused = false
	get_tree().paused = false
	SoundManager.playSound(SoundManager.SOUND.CLICK)
	show()
	main_menu_buttons.modulate = Color.WHITE
	main_menu_buttons.show()


func update_level_beaten_states(status_arr: Array[bool]) -> void:
	print("states: ", status_arr)
	if not is_inside_tree():
		await tree_entered
	var children = level_options._grid_container.get_children()
	for i in range(children.size()):
		children[i].modulate = Color.GREEN if status_arr[i] else Color.WHITE
	pass