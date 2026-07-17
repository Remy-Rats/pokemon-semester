extends Node

const SAVE_PATH = "user://pokemon_semester_save.json"

var trainer_name: String = ""
var major: String = ""
var school_year: String = ""
var character_index: int = 0
var classes: Array[String] = []
var class_pokemon_ids: Array[int] = []

func save_game() -> void:
	var save_data = {
		"trainer_name": trainer_name,
		"major": major,
		"school_year": school_year,
		"character_index": character_index,
		"classes": classes,
		"class_pokemon_ids": class_pokemon_ids
	}

	var save_file = FileAccess.open(SAVE_PATH, FileAccess.WRITE)

	if save_file == null:
		print("Could not create save file.")
		return

	save_file.store_string(JSON.stringify(save_data))
	print("Game saved!")


func load_game() -> bool:
	if not FileAccess.file_exists(SAVE_PATH):
		print("No save file found.")
		return false

	var save_file = FileAccess.open(SAVE_PATH, FileAccess.READ)

	if save_file == null:
		print("Could not open save file.")
		return false

	var save_data = JSON.parse_string(save_file.get_as_text())

	if save_data == null:
		print("Could not read save data.")
		return false

	trainer_name = save_data.get("trainer_name", "")
	major = save_data.get("major", "")
	school_year = save_data.get("school_year", "")
	character_index = int(save_data.get("character_index", 0))

	classes.clear()

	for saved_class in save_data.get("classes", []):
		classes.append(str(saved_class))

	print("Game loaded!")
	return true
	
	class_pokemon_ids.clear()

	for pokemon_id in save_data.get("class_pokemon_ids", []):
		class_pokemon_ids.append(int(pokemon_id))

func delete_save() -> void:
	if FileAccess.file_exists(SAVE_PATH):
		DirAccess.remove_absolute(SAVE_PATH)
		print("Save deleted.")
	else:
		print("No save file found.")
