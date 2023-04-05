extends Control


signal resume_game
signal reset_game


func reset_menu() -> void:
	%Title.text = "checking out"	
	if Globals.is_main_menu:
		$TabContainer/MainOptions/Begin.text = "begin"
		$TabContainer/MainOptions/Reset.visible = false
	else:
		$TabContainer/MainOptions/Begin.text = "resume"
		$TabContainer/MainOptions/Reset.visible = true
	$TabContainer.current_tab = 0


func _ready() -> void:
	Globals.is_main_menu = true
	reset_menu()


func _on_begin_pressed() -> void:
	resume_game.emit()


func _on_reset_pressed() -> void:
	$ResetConfirmationDialog.popup_centered(Vector2i(600, 200))


func _on_reset_confirmation_dialog_confirmed():
	reset_game.emit()


func _on_instructions_pressed() -> void:
	%Title.text = "instructions"
	$TabContainer.current_tab = 1


func _on_instructions_back_pressed() -> void:
	reset_menu()


func _on_settings_pressed() -> void:
	%Title.text = "settings"
	$TabContainer.current_tab = 2


func _on_fullscreen_toggled(button_pressed: bool) -> void:
	if button_pressed:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
	else:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)


func _on_invert_y_toggled(button_pressed: bool) -> void:
	Globals.invert_y = button_pressed


func _on_controls_pressed():
	$ControlsAcceptDialog.popup_centered(Vector2(400, 200))


func _on_settings_back_pressed() -> void:
	reset_menu()


func _on_credits_pressed() -> void:
	%Title.text = "credits"
	$TabContainer.current_tab = 3


func _on_credits_meta_clicked(meta: Variant) -> void:
	if OS.get_name() != "HTML5":
		OS.shell_open(str(meta))


func _on_credits_back_pressed() -> void:
	reset_menu()


func _on_leave_pressed() -> void:
	$LeaveConfirmationDialog.popup_centered(Vector2i(600, 200))


func _on_leave_confirmation_dialog_confirmed() -> void:
	get_tree().quit()
