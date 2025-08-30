extends Node2D

@onready var debug_container: MarginContainer = $CanvasLayer/contDebug
@onready var game_overlay_contaienr: MarginContainer = $CanvasLayer/contGameOverlay
@onready var ready_container: CenterContainer = $CanvasLayer/contReady
@onready var paused_container: MarginContainer = $CanvasLayer/contPaused
@onready var return_container: MarginContainer = $CanvasLayer/contReturn
@onready var game_over_container: CenterContainer = $CanvasLayer/contGameOver

@onready var score_label := $CanvasLayer/contGameOverlay/VBoxContainer/HBoxContainer/lScore
@onready var high_score_label := $CanvasLayer/contGameOverlay/VBoxContainer/HBoxContainer2/lHiScore
@onready var lives_label := $CanvasLayer/contGameOverlay/VBoxContainer/HBoxContainer/lLives

@onready var timer_ready := $TimerReady

@export var score: int = 0
@export var ready_time: int = 3

@export var player_lives: int = 3
var PLAYER_STARTING_LIVES: int = 3

signal play_game
signal player_respawn

func prepare_game():
	Globals.current_state = Globals.State.PREPARE
	score = 0
	update_score_ui(true)
	update_lives_ui()
	timer_ready.start(ready_time)
	player_lives = PLAYER_STARTING_LIVES

func _ready() -> void:
	prepare_game()
	
func _process(delta: float) -> void:
	if(Input.is_action_just_pressed("pause")):
		toggle_paused()

func update_score_ui(update_hi_score: bool):
	score_label.text = "Score: %d" % score
	if update_hi_score:
		high_score_label.text = "High score: %d" % Globals.high_score


func _on_timer_ready_timeout() -> void:
	Globals.current_state = Globals.State.PLAYING
	ready_container.visible = false

func player_dead():
	game_overlay_contaienr.visible = false
	game_over_container.visible = true

func add_points() -> void:
	score += 10
	update_score_ui(false)
	
func player_hit() -> void:
	player_lives -= 1
	print("Player hit")
	if(player_lives == 0):
		player_dead()
	else:
		player_respawn.emit()
		update_lives_ui()
	
# UI CODE
func toggle_paused():
	if(Globals.current_state == Globals.State.PLAYING):
		Globals.current_state = Globals.State.PAUSED
		paused_container.visible = true
	elif (Globals.current_state == Globals.State.PAUSED):
		Globals.current_state = Globals.State.PLAYING
		paused_container.visible = false
		
func toggle_quit(show_quit: bool) -> void:
	if show_quit:
		paused_container.visible = false
		return_container.visible = true
	else:
		return_container.visible = false
		paused_container.visible = true
	
func update_lives_ui():
	lives_label.text = "Lives: %d" % player_lives
	
func _on_b_resume_button_up() -> void:
	toggle_paused()


func _on_b_quit_pressed() -> void:
	toggle_quit(true)


func _on_b_confirm_quit_button_up() -> void:
	get_tree().change_scene_to_file("res://Scenes/main_menu_scene.tscn")


func _on_b_back_to_pause_button_up() -> void:
	toggle_quit(false)


func _on_b_restart_button_up() -> void:
	get_tree().reload_current_scene()
