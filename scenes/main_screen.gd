extends Control

var pokemon_level: int = 1
var pokemon_xp: int = 0
var selected_class: int = -1

func _ready() -> void:
	$MainLayout/Header/UserButton.text = GameData.trainer_name

	print("Trainer: ", GameData.trainer_name)
	print("Major: ", GameData.major)
	print("Year: ", GameData.school_year)
	print("Character: ", GameData.character_index)
	update_class_buttons()


func select_class(class_index: int) -> void:
	if class_index >= GameData.class_pokemon_ids.size():
		return

	selected_class = class_index

	$MainLayout/Body/PokemonPanel/PokemonDisplay/PokemonNameLabel.text = "Loading..."

	var pokemon_id = GameData.class_pokemon_ids[class_index]

	var error = $PokemonRequest.request(
		"https://pokeapi.co/api/v2/pokemon/" + str(pokemon_id)
	)

	if error != OK:
		print("Could not start Pokémon request.")


func _on_class_button_1_pressed() -> void:
	select_class(0)

func _on_class_button_2_pressed() -> void:
	select_class(1)

func _on_class_button_3_pressed() -> void:
	select_class(2)

func _on_class_button_4_pressed() -> void:
	select_class(3)

func _on_class_button_5_pressed() -> void:
	select_class(4)

func _on_class_button_6_pressed() -> void:
	select_class(5)

func _on_pokemon_request_request_completed(
	_result,
	response_code,
	_headers,
	body
):
	if response_code != 200:
		print("PokéAPI request failed. Code: ", response_code)
		return

	var json = JSON.parse_string(body.get_string_from_utf8())

	if json == null:
		print("Could not read Pokémon data.")
		return

	var pokemon_name = json["name"].capitalize()
	var sprite_url = json["sprites"]["front_default"]

	$MainLayout/Body/PokemonPanel/PokemonDisplay/PokemonNameLabel.text = pokemon_name

	if sprite_url != null:
		var sprite_error = $SpriteRequest.request(sprite_url)

		if sprite_error != OK:
			print("Could not start sprite request.")

	print("Loaded Pokémon: ", pokemon_name)


func _on_sprite_request_request_completed(
	_result,
	response_code,
	_headers,
	body
):
	if response_code != 200:
		print("Sprite request failed. Code: ", response_code)
		return

	var image = Image.new()
	var image_error = image.load_png_from_buffer(body)

	if image_error != OK:
		print("Could not read sprite image.")
		return

	var texture = ImageTexture.create_from_image(image)

	$MainLayout/Body/PokemonPanel/PokemonDisplay/PokemonSprite.texture = texture

func update_class_buttons() -> void:
	var class_buttons = [
		$MainLayout/Body/ClassesPanel/ClassesList/ClassButton1,
		$MainLayout/Body/ClassesPanel/ClassesList/ClassButton2,
		$MainLayout/Body/ClassesPanel/ClassesList/ClassButton3,
		$MainLayout/Body/ClassesPanel/ClassesList/ClassButton4,
		$MainLayout/Body/ClassesPanel/ClassesList/ClassButton5,
		$MainLayout/Body/ClassesPanel/ClassesList/ClassButton6
	]

	for i in range(class_buttons.size()):
		if i < GameData.classes.size():
			class_buttons[i].text = GameData.classes[i]
			class_buttons[i].disabled = false
		else:
			class_buttons[i].text = "Empty Slot"
			class_buttons[i].disabled = true


func _on_edit_classes_button_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/class_setup.tscn")


func _on_main_menu_button_pressed() -> void:
	print("MAIN MENU BUTTON PRESSED")
	GameData.save_game()
	get_tree().change_scene_to_file("res://scenes/title_screen.tscn")
