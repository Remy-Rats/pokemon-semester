extends Control

const COMMON_POKEMON_IDS = [
	1, 4, 7, 10, 13,
	16, 19, 10091, 21, 23,
	25, 27, 10101, 29, 32,
	37, 10103, 41, 43, 46,
	48, 50, 10105, 52, 10107,
	10161, 54, 56, 58, 60, 63,
	66, 69, 72, 74, 77, 79,
	81, 84, 88, 90, 92, 96,
	98, 100, 102, 104, 109,
	111, 114, 116, 118, 120,
	129, 133, 152, 155, 158,
	161, 163, 165, 167, 170,
	172, 173, 174, 175, 177,
	179, 187, 190, 191, 193,
	194, 198, 200, 204, 209,
	215, 216, 218, 220, 223,
	228, 231, 236, 238, 239,
	240, 252, 255, 258, 261,
	263, 10174, 265, 270,
	273, 276, 278, 280, 283,
	285, 287, 290, 293, 296,
	298, 299, 300, 304, 307,
	309, 316, 318, 320, 322,
	325, 328, 331, 333, 339,
	341, 343, 353, 355, 360,
	361, 363, 366, 387, 390,
	393, 396, 399, 401, 403,
	406, 412, 415, 418, 420,
	422, 425, 427, 431, 433,
	434, 436, 438, 439, 440,
	446, 447, 449, 451, 453,
	456, 458, 459, 495, 498,
	501, 504, 506, 509, 511,
	513, 515, 517, 519, 522,
	524, 527, 529, 532, 535,
	540, 543, 546, 548, 551,
	554, 10176, 557, 559,
	562, 10180, 568, 570,
	10238, 572, 574, 577,
	580, 582, 585, 588,
	590, 592, 595, 597,
	599, 602, 605, 607,
	613, 616, 619, 622, 624,
	627, 629, 650, 653, 656,
	659, 661, 664, 667, 669,
	672, 674, 677, 679, 682,
	684, 686, 688, 690, 692,
	694, 708, 710, 712, 714,
	722, 725, 728, 731, 734,
	736, 739, 742, 744, 747,
	749, 751, 753, 755, 757,
	759, 761, 767, 769, 810,
	813, 816, 819, 821, 824,
	827, 829, 831, 833, 835,
	837, 843, 846, 848, 850,
	852, 854, 856, 859, 868,
	878, 906, 909, 912, 915,
	917, 919, 921, 924, 926,
	928, 932, 935, 938, 940,
	942, 944, 946, 948, 951,
	953, 955, 957, 960, 963,
	965, 969, 971, 974
]
const UNCOMMON_POKEMON_IDS = [
	10229, 10109, 10162, 10164,
	86, 10112, 95, 10231, 108,
	123, 127, 128, 138, 140,
	10253, 203, 206, 207, 211,
	10078, 222, 10175, 227,
	241, 302, 311, 312, 313,
	314, 324, 335, 336, 345,
	347, 349, 351, 352, 369,
	370, 408, 410, 417, 538,
	539, 550, 556, 564, 566,
	587, 594, 615, 618, 10180,
	626,  631, 632, 636, 696,
	698, 701, 702, 703, 707,
	764, 765, 766, 771, 775,
	777, 778, 779, 781, 845,
	870, 871, 872, 874, 875,
	876, 877, 880, 881, 882,
	883, 884, 931, 950, 962,
	967, 968, 973, 976, 977,
	999, 1012
]
const RARE_POKEMON_IDS = [
	83, 10166, 115, 10419,
	10251, 10252, 131, 132,
	137, 142, 147, 201, 10234,
	213, 214, 234, 235, 246,
	303, 327, 337, 338, 357,
	359, 371, 374, 441, 442,
	443, 455, 479, 531, 561,
	563, 610, 621, 633, 676,
	704, 741, 746, 772, 774,
	776, 780, 782, 840, 885,
	978, 996
]

func choose_random_pokemon_id() -> int:
	var rarity_roll = randi_range(1, 100)

	if rarity_roll <= 70:
		return COMMON_POKEMON_IDS.pick_random()
	elif rarity_roll <= 95:
		return UNCOMMON_POKEMON_IDS.pick_random()
	else:
		return RARE_POKEMON_IDS.pick_random()


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
	
	while GameData.class_pokemon_xp.size() < GameData.classes.size():
		GameData.class_pokemon_xp.append(0)

	while GameData.class_pokemon_xp.size() > GameData.classes.size():
		GameData.class_pokemon_xp.pop_back()
	
	while GameData.class_pokemon_levels.size() < GameData.classes.size():
		GameData.class_pokemon_levels.append(1)

	while GameData.class_pokemon_levels.size() > GameData.classes.size():
		GameData.class_pokemon_levels.pop_back()

	GameData.save_game()

	get_tree().change_scene_to_file("res://scenes/main_screen.tscn")
	
