extends Node
var high_score: int = 0

enum State {MENU, PREPARE, PLAYING, PAUSED, GAME_OVER}
var current_state: int = State.PREPARE
var music_volume: int = 100
var sfx_volume: int = 100

var DEBUG_MODE: bool = true 

var asteroid_small: PackedScene = preload("res://Scenes/entities/asteroid_small_obj.tscn")
var asteroid_medium: PackedScene = preload("res://Scenes/entities/asteroid_med_obj.tscn")
var asteroid_large: PackedScene = preload("res://Scenes/entities/asteroid_big_obj.tscn")

var asteroids: Array[Variant] = [asteroid_small, asteroid_medium, asteroid_large]

#Use these scenes to instantiate new asteroids
func get_asteroid(loc: int) -> Variant:
	return asteroids[loc]

#Saves the game data to device
func save_game():
	var save_file = FileAccess.open("user://savegame.save", FileAccess.WRITE)
	var save_data = create_save_data()
	var json_string = JSON.stringify(save_data)
	save_file.store_line(json_string)

func load_game():
	if not FileAccess.file_exists("user://savegame.save"):
		return # Error! We don't have a save to load.
	
	var save_file = FileAccess.open("user://savegame.save", FileAccess.READ)
	while save_file.get_position() < save_file.get_length():
		var json_string = save_file.get_line()

		# Creates the helper class to interact with JSON.
		var json = JSON.new()

		# Check if there is any error while parsing the JSON string, skip in case of failure.
		var parse_result = json.parse(json_string)
		if not parse_result == OK:
			print("JSON Parse Error: ", json.get_error_message(), " in ", json_string, " at line ", json.get_error_line())
			continue

		# Get the data from the JSON object.
		var node_data = json.data
		high_score = node_data["high_score"]
		music_volume = node_data["music_vol"]
		sfx_volume = node_data["sfx_vol"]
	
#Creates the data in a structure ready to save it
func create_save_data():
	var save_dict ={
		"high_score" : high_score,
		"music_vol" : music_volume,
		"sfx_vol" : sfx_volume
	}
	return save_dict
