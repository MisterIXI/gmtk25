extends Control

@onready var main_menu_buttons = %MainMenuButtons
@onready var user_options = %UserOptions

var active_tween: Tween

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

	user_options.visible = false
	user_options.modulate.a = 0.0

func _on_start_game_button_pressed() -> void:
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
	get_tree().quit()
	
func _show_options_menu() -> void:
	if main_menu_buttons and is_instance_valid(main_menu_buttons):
		main_menu_buttons.visible = false
	if user_options and is_instance_valid(user_options):
		user_options.visible = true

#thanks ai for showing me some fucking stupid fixes. I dont know
func _show_main_menu() -> void:
	if user_options and is_instance_valid(user_options):
		user_options.visible = false
	if main_menu_buttons and is_instance_valid(main_menu_buttons):
		main_menu_buttons.visible = true
