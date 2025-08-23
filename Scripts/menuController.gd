extends Node2D

@onready var c_main: VBoxContainer = $CanvasLayer/marginContainerMenu/MainMenuContainer
@onready var c_how_to: CenterContainer = $CanvasLayer/marginContainerMenu/containerHowTo
@onready var c_options: CenterContainer = $CanvasLayer/marginContainerMenu/containerOptions
@onready var c_quit: CenterContainer = $CanvasLayer/marginContainerMenu/containerQuit


func _ready() -> void:
	Globals.load_game()

func _on_b_play_button_up() -> void:
	get_tree().change_scene_to_file("res://Scenes/game_loop.tscn")


func _on_b_how_to_button_up() -> void:
	c_main.visible = false
	c_how_to.visible = true


func _on_b_options_button_up() -> void:
	c_main.visible = false
	c_options.visible = true


func _on_b_quit_button_up() -> void:
	c_main.visible = false
	c_quit.visible = true


func _on_b_back_button_up() -> void:
	c_options.visible = false
	c_how_to.visible = false
	c_main.visible = true


func _on_b_no_button_up() -> void:
	c_quit.visible = false
	c_main.visible = true


func _on_b_yes_button_up() -> void:
	get_tree().quit(0)
