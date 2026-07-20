extends Control

var pokemon_level: int = 1
var pokemon_xp: int = 0
var selected_class: int = -1
var evolution_check_class: int = -1
var evolution_check_level: int = 1
var evolution_current_name: String = ""

func xp_needed_for_level(level: int) -> int:
	return 40 + ((level - 1) * 15)


func attendance_xp_for_level(level: int) -> int:
	return 10 + ((level - 1) * 2)

func _ready() -> void:
	$MainLayout/Header/UserButton.text = GameData.trainer_name

	print("Trainer: ", GameData.trainer_name)
	print("Major: ", GameData.major)
	print("Year: ", GameData.school_year)
	print("Character: ", GameData.character_index)
	update_class_buttons()
	update_attend_button()


func select_class(class_index: int) -> void:
	if class_index >= GameData.class_pokemon_ids.size():
		return

	selected_class = class_index
	
	var current_level = GameData.class_pokemon_levels[selected_class]
	var current_xp = GameData.class_pokemon_xp[selected_class]
	var needed_xp = xp_needed_for_level(current_level)

	update_attend_button()

	$MainLayout/Body/PokemonPanel/PokemonDisplay/PokemonXPBar.max_value = needed_xp
	$MainLayout/Body/PokemonPanel/PokemonDisplay/PokemonXPBar.value = current_xp
	$MainLayout/Body/PokemonPanel/PokemonDisplay/PokemonLevelLabel.text = "Level " + str(current_level)

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

func _on_attend_class_button_pressed() -> void:
	if selected_class == -1:
		print("Select a class first.")
		return

	if selected_class >= GameData.class_pokemon_xp.size():
		return
	
	var today = Time.get_date_string_from_system()

	if GameData.class_last_attended_dates[selected_class] == today:
		print("You've already attended this class today.")
		return

	var current_level = GameData.class_pokemon_levels[selected_class]
	var gained_xp = attendance_xp_for_level(current_level)

	GameData.class_pokemon_xp[selected_class] += gained_xp

	var needed_xp = xp_needed_for_level(current_level)

	while GameData.class_pokemon_xp[selected_class] >= needed_xp:
		GameData.class_pokemon_xp[selected_class] -= needed_xp
		GameData.class_pokemon_levels[selected_class] += 1
		check_for_evolution(selected_class)

	current_level = GameData.class_pokemon_levels[selected_class]
	needed_xp = xp_needed_for_level(current_level)

	print("Level Up! Level ", current_level)

	var current_xp = GameData.class_pokemon_xp[selected_class]

	$MainLayout/Body/PokemonPanel/PokemonDisplay/PokemonXPBar.max_value = needed_xp
	$MainLayout/Body/PokemonPanel/PokemonDisplay/PokemonXPBar.value = current_xp
	$MainLayout/Body/PokemonPanel/PokemonDisplay/PokemonLevelLabel.text = "Level " + str(current_level)

	GameData.class_last_attended_dates[selected_class] = today

	GameData.save_game()

	update_attend_button()

	print("Gained ", gained_xp, " XP")

func check_for_evolution(class_index: int) -> void:
	if class_index < 0:
		return

	if class_index >= GameData.class_pokemon_ids.size():
		return

	evolution_check_class = class_index
	evolution_check_level = GameData.class_pokemon_levels[class_index]

	var pokemon_id = GameData.class_pokemon_ids[class_index]

	var error = $EvolutionSpeciesRequest.request(
		"https://pokeapi.co/api/v2/pokemon-species/" + str(pokemon_id)
	)

	if error != OK:
		print("Could not start evolution species request.")

func _on_evolution_species_request_request_completed(
	_result,
	response_code,
	_headers,
	body
) -> void:
	if response_code != 200:
		print("Evolution species request failed.")
		return

	var data = JSON.parse_string(body.get_string_from_utf8())

	if data == null:
		print("Could not read evolution species data.")
		return

	evolution_current_name = data["name"]

	var evolution_chain_url = data["evolution_chain"]["url"]

	var error = $EvolutionChainRequest.request(evolution_chain_url)

	if error != OK:
		print("Could not start evolution chain request.")

func _find_current_evolution_node(chain_node: Dictionary, pokemon_name: String):
	if chain_node["species"]["name"] == pokemon_name:
		return chain_node

	for next_node in chain_node["evolves_to"]:
		var found_node = _find_current_evolution_node(next_node, pokemon_name)

		if found_node != null:
			return found_node

	return null

func _on_evolution_chain_request_request_completed(
	_result,
	response_code,
	_headers,
	body
) -> void:
	if response_code != 200:
		print("Evolution chain request failed.")
		return

	var data = JSON.parse_string(body.get_string_from_utf8())

	if data == null:
		print("Could not read evolution chain.")
		return

	var current_node: Variant = _find_current_evolution_node(
	data["chain"],
	evolution_current_name
)

	if current_node == null:
		return

	var current_node_data: Dictionary = current_node

	for next_evolution in current_node_data["evolves_to"]:
		var details = next_evolution["evolution_details"]

		if details.is_empty():
			continue

		var requirement = details[0]
		var trigger_name = requirement["trigger"]["name"]
		var minimum_level = requirement["min_level"]

		if trigger_name != "level-up":
			continue

		if minimum_level == null:
			continue

		if evolution_check_level < int(minimum_level):
			continue

		var evolved_name = next_evolution["species"]["name"]

		request_evolved_pokemon_id(evolved_name)
		return

func request_evolved_pokemon_id(pokemon_name: String) -> void:
	var error = $EvolvedPokemonRequest.request(
		"https://pokeapi.co/api/v2/pokemon/" + pokemon_name
	)

	if error != OK:
		print("Could not request evolved Pokémon.")

func _on_evolved_pokemon_request_request_completed(
	_result,
	response_code,
	_headers,
	body
) -> void:
	if response_code != 200:
		print("Evolved Pokémon request failed.")
		return

	var data = JSON.parse_string(body.get_string_from_utf8())

	if data == null:
		return

	var evolved_id = int(data["id"])
	var evolved_name = str(data["name"]).capitalize()

	GameData.class_pokemon_ids[evolution_check_class] = evolved_id
	GameData.save_game()

	print("Your Pokémon evolved into ", evolved_name, "!")

	if evolution_check_class == selected_class:
		select_class(selected_class)


func update_attend_button() -> void:
	var attend_button = $MainLayout/Body/PokemonPanel/PokemonDisplay/AttendClassButton

	if selected_class == -1:
		attend_button.disabled = true
		attend_button.text = "Select a Class"
		return

	if selected_class >= GameData.class_last_attended_dates.size():
		attend_button.disabled = true
		return

	var today = Time.get_date_string_from_system()
	var attended_today = GameData.class_last_attended_dates[selected_class] == today

	attend_button.disabled = attended_today

	if attended_today:
		attend_button.text = "Attended Today"
	else:
		attend_button.text = "Attend Class"


func _on_main_menu_button_pressed() -> void:
	print("MAIN MENU BUTTON PRESSED")
	GameData.save_game()
	get_tree().change_scene_to_file("res://scenes/title_screen.tscn")
