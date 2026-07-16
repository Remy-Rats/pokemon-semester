extends Control

var character_options: Array[Texture2D] = [
	preload("res://assets/character_1.png"),
	preload("res://assets/character_2.png"),

]

var selected_character: int = 0


func _ready() -> void:
	update_character()


func update_character() -> void:
	$MainLayout/CreationArea/CharacterPanel/CharacterPreview/CharacterSprite.texture = character_options[selected_character]


func _on_change_character_button_pressed() -> void:
	selected_character += 1

	if selected_character >= character_options.size():
		selected_character = 0

	update_character()


func _on_button_pressed() -> void:
	GameData.trainer_name = $MainLayout/CreationArea/InformationPanel/InformationForm/TrainerNameInput.text

	GameData.major = $MainLayout/CreationArea/InformationPanel/InformationForm/MajorInput.text

	GameData.school_year = $MainLayout/CreationArea/InformationPanel/InformationForm/SchoolYearDropdown.text

	GameData.character_index = selected_character

	get_tree().change_scene_to_file(
		"res://scenes/class_setup.tscn"
	)
