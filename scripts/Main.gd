extends Control


var game_end_text: String


func pause() -> void:
	Globals.paused = true
	get_tree().paused = true
	$Crosshair.visible = false
	$Menu.visible = true
	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE


func _ready() -> void:
	pause()
	game_end_text = $ScoreAcceptDialog.dialog_text


func _input(event: InputEvent) -> void:
	if event.is_action_pressed("pause"):
		if Globals.paused:
			_on_menu_resume_game()
		else:
			pause()


func _on_menu_reset_game() -> void:
	if Globals.is_main_menu:
		return
	
	Globals.is_main_menu = true
	$Menu.reset_menu()
	$Room.reset_game()


func _on_menu_resume_game() -> void:
	if Globals.is_main_menu:
		Globals.is_main_menu = false
		$Room.use_player_camera()
	Globals.paused = false
	get_tree().paused = false
	$Crosshair.visible = true
	$Menu.reset_menu()
	$Menu.visible = false
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED


func _on_room_end_game():
	pause()
	_on_menu_reset_game()

	var epilogue_text: String
	var epilogue_button: String
	if Globals.player_collected < 5:
		if Globals.school_collected > 0:
			epilogue_text = "FAIL\nyou didn't collect all your stuff!\nalso, you've been fined quite a lot for stealing"
		else:
			epilogue_text = "FAIL\nyou didn't collect all your stuff!"
		epilogue_button = "oops"
	else:
		if Globals.school_collected > 0:
			epilogue_text = "FAIL\nyou collected all your stuff!\nbut, you've been fined quite a lot for stealing"
			epilogue_button = "oops"
		else:
			epilogue_text = "SUCCESS\nyou collected all your stuff without stealing!"
			epilogue_button = "sweet"
	
	$ScoreAcceptDialog.dialog_text = game_end_text % [Globals.player_collected, Globals.school_collected, epilogue_text]
	$ScoreAcceptDialog.ok_button_text = epilogue_button
	Globals.inside_end_zone = false
	Globals.player_collected = 0
	Globals.school_collected = 0
	$ScoreAcceptDialog.popup_centered(Vector2i(300, 200))
