extends Control

const COMMON_POKEMON_IDS = [
	1, 4, 7, 19, 21,
	23, 27, 29, 32, 41,
	43, 46, 48, 50, 52,
	54, 60, 69, 72, 74
]

func _ready() -> void:
	var class_inputs = [
		$MainLayout/ClassLayout/ClassEdit1,
		$MainLayout/ClassLayout/ClassEdit2,
		$MainLayout/ClassLayout/ClassEdit3,
		$MainLayout/ClassLayout/ClassEdit4,
		$MainLayout/ClassLayout/ClassEdit5,
		$MainLayout/ClassLayout/ClassEdit6
	]

	for i in range(class_inputs.size()):
		if i < GameData.classes.size():
			class_inputs[i].text = GameData.classes[i]

func _on_button_pressed() -> void:
	GameData.classes.clear()
	var class_inputs = [
		$MainLayout/ClassLayout/ClassEdit1,
		$MainLayout/ClassLayout/ClassEdit2,
		$MainLayout/ClassLayout/ClassEdit3,
		$MainLayout/ClassLayout/ClassEdit4,
		$MainLayout/ClassLayout/ClassEdit5,
		$MainLayout/ClassLayout/ClassEdit6
	]
	

	for class_input in class_inputs:
		var entered_class = class_input.text.strip_edges()

		if entered_class != "":
			GameData.classes.append(entered_class)
	

	var available_ids = COMMON_POKEMON_IDS.duplicate()

	for pokemon_id in GameData.class_pokemon_ids:
		available_ids.erase(pokemon_id)

	while GameData.class_pokemon_ids.size() < GameData.classes.size():
		if available_ids.is_empty():
			break

		var random_id = available_ids.pick_random()
		GameData.class_pokemon_ids.append(random_id)
		available_ids.erase(random_id)


	while GameData.class_pokemon_ids.size() > GameData.classes.size():
		GameData.class_pokemon_ids.pop_back()

	GameData.save_game()

	get_tree().change_scene_to_file("res://scenes/main_screen.tscn")
	
