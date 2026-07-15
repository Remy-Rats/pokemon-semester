extends Control

var pokemon_level: int = 1
var pokemon_xp: int = 0
var selected_class: int = -1


func _on_class_button_1_pressed() -> void:
	selected_class = 0

	$MainLayout/Body/PokemonPanel/PokemonDisplay/PokemonNameLabel.text = "Test Pokémon"
	$MainLayout/Body/PokemonPanel/PokemonDisplay/PokemonLevelLabel.text = "Level " + str(pokemon_level)

	print("Class 1 clicked")
