extends Node2D

@onready var debug_container: MarginContainer = $CanvasLayer/contDebug
@onready var game_overlay_contaienr: MarginContainer = $CanvasLayer/contGameOverlay
@onready var ready_container: CenterContainer = $CanvasLayer/contReady

@onready var score_label := $CanvasLayer/contGameOverlay/VBoxContainer/HBoxContainer/lScore
@onready var high_score_label := $CanvasLayer/contGameOverlay/VBoxContainer/HBoxContainer2/lHiScore

@onready var timer_ready := $TimerReady

@export var score: int = 0
@export var ready_time: int = 3

signal play_game

func prepare_game():
	Globals.current_state = Globals.State.PREPARE
	score = 0
	update_score_ui(true)
	timer_ready.start(ready_time)

func _ready() -> void:
	prepare_game()

func update_score_ui(update_hi_score: bool):
	score_label.text = "Score: %d" % score
	if update_hi_score:
		high_score_label.text = "High score: %d" % Globals.high_score


func _on_timer_ready_timeout() -> void:
	Globals.current_state = Globals.State.PLAYING
	ready_container.visible = false
