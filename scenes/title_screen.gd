extends Control

func _ready() -> void:
	GameData.load_game()

	$TitleScreenBackground/TitleLayout/MarginContainer/ButtonContainer/ContinueButton.disabled = GameData.classes.is_empty()


func _on_quit_button_pressed() -> void:
	get_tree().quit()

func _on_start_button_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/character_creation.tscn")

func _on_continue_button_pressed() -> void:
	if GameData.load_game():
		get_tree().change_scene_to_file("res://scenes/main_screen.tscn")
	else:
		print("There are no saves.")

func _on_reset_save_data_button_pressed() -> void:
	GameData.delete_save()
	GameData.trainer_name = ""
	GameData.major = ""
	GameData.school_year = ""
	GameData.character_index = 0
	GameData.classes.clear()
	GameData.class_pokemon_ids.clear()

	$TitleScreenBackground/TitleLayout/MarginContainer/ButtonContainer/ContinueButton.disabled = true

	print("All progress deleted.")
