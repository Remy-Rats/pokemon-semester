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


func _on_class_button_1_pressed():
	selected_class = 0
	

	$MainLayout/Body/PokemonPanel/PokemonDisplay/PokemonNameLabel.text = "Loading..."

	var error = $PokemonRequest.request(
		"https://pokeapi.co/api/v2/pokemon/1"
	)

	if error != OK:
		print("Could not start Pokémon request.")


func _on_pokemon_request_request_completed(
	result,
	response_code,
	headers,
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
	result,
	response_code,
	headers,
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
