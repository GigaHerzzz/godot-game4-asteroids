extends Node2D

@onready var margin_container_menu: MarginContainer = $CanvasLayer/marginContainerMenu

@onready var c_main: VBoxContainer = $CanvasLayer/marginContainerMenu/MainMenuContainer
@onready var c_how_to: CenterContainer = $CanvasLayer/marginContainerMenu/containerHowTo
@onready var c_options: CenterContainer = $CanvasLayer/marginContainerMenu/containerOptions
@onready var c_quit: CenterContainer = $CanvasLayer/marginContainerMenu/containerQuit

@export var transition_time: float = 0.75
@export var main_transition_time: float = 1

func _ready() -> void:
	Globals.load_game()
	$CanvasLayer/marginContainerMenu/containerOptions/VBoxContainer/HBoxContainer/MusicSlider.value = Globals.music_volume
	$CanvasLayer/marginContainerMenu/containerOptions/VBoxContainer/HBoxContainer2/SfxSlider.value = Globals.sfx_volume
	$CanvasLayer/marginContainerMenu/containerOptions/VBoxContainer/HBoxContainer/MusicVal.text = str(int(Globals.music_volume))
	$CanvasLayer/marginContainerMenu/containerOptions/VBoxContainer/HBoxContainer2/SfxVal.text	= str(int(Globals.sfx_volume))
#tween_main_menu_appears()
	#TweenBus.tween_button.connect(tween_menu_element_scale)
	#Skip to the game, maybe make a debug window and use this
	#if(Globals.current_state == Globals.State.PREPARE):
	#	get_tree().change_scene_to_file("res://Scenes/game_loop.tscn")

func tween_menu_element_scale(node: Control, val: String, variable: Vector2, time: int):
	var inst_tween: Tween = get_tree().create_tween()
	inst_tween.tween_property(node, val, variable, time)
	pass

func tween_menu_fade_out(node: Control, new_pos: Vector2):
	var tween_fade_out: Tween = get_tree().create_tween().set_parallel(true).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT)
	tween_fade_out.tween_property(margin_container_menu, "position", new_pos, transition_time)
	tween_fade_out.tween_property(node, "modulate", Color(1,1,1,0), transition_time)

func tween_menu_fade_in(node: Control, new_pos: Vector2):
	var tween_fade_in: Tween = get_tree().create_tween().set_parallel(true).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT)
	tween_fade_in.tween_property(margin_container_menu, "position", new_pos, transition_time)
	tween_fade_in.tween_property(node, "modulate", Color(1,1,1,1), transition_time)
	
func tween_main_menu_appears():
	var begin_tween: Tween = get_tree().create_tween().set_parallel(true).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT)
	begin_tween.tween_property(margin_container_menu,"position", Vector2.ZERO, main_transition_time)
	begin_tween.tween_property(margin_container_menu,"modulate", Color(1,1,1,1), main_transition_time)

func _on_b_play_button_up() -> void:
	$CanvasLayer/ColorRect.visible = true
	$AnimationPlayer.play("transition")
	#get_tree().change_scene_to_file("res://Scenes/game_loop.tscn")


func _on_b_how_to_button_up() -> void:
	tween_menu_fade_out(c_main, Vector2(-50,0))
	await get_tree().create_timer(transition_time).timeout
	#margin_container_menu.position = Vector2(50,0)
	#await get_tree().create_timer(0.1).timeout
	c_main.visible = false
	c_how_to.visible = true
	tween_menu_fade_in(c_how_to, Vector2(0,0))
	#c_main.visible = false
	#c_how_to.visible = true


func _on_b_options_button_up() -> void:
	tween_menu_fade_out(c_main, Vector2(-50,0))
	await get_tree().create_timer(transition_time).timeout
	#margin_container_menu.position = Vector2(50,0)
	#await get_tree().create_timer(0.1).timeout
	c_main.visible = false
	c_options.visible = true
	tween_menu_fade_in(c_options, Vector2(0,0))


func _on_b_quit_button_up() -> void:
	tween_menu_fade_out(c_main, Vector2(-50,0))
	await get_tree().create_timer(transition_time).timeout
	#margin_container_menu.position = Vector2(50,0)
	#await get_tree().create_timer(0.1).timeout
	c_main.visible = false
	c_quit.visible = true
	tween_menu_fade_in(c_quit, Vector2(0,0))


func _on_b_back_button_up() -> void:
	var visible_menu
	if(c_how_to.visible):
		visible_menu = c_how_to
	else:
		visible_menu = c_options
		Globals.save_game()
	
	tween_menu_fade_out(visible_menu, Vector2(-50,0))
	await get_tree().create_timer(transition_time).timeout
	#margin_container_menu.position = Vector2(50,0)
	#await get_tree().create_timer(0.1).timeout
	visible_menu.visible = false
	c_main.visible = true
	tween_menu_fade_in(c_main, Vector2(0,0))


func _on_b_no_button_up() -> void:
	tween_menu_fade_out(c_quit, Vector2(-50,0))
	await get_tree().create_timer(transition_time).timeout
	#margin_container_menu.position = Vector2(50,0)
	#await get_tree().create_timer(0.1).timeout
	c_quit.visible = false
	c_main.visible = true
	tween_menu_fade_in(c_main, Vector2(0,0))


func _on_b_yes_button_up() -> void:
	get_tree().quit(0)

func _on_b_play_mouse_entered() -> void:
	#tween_menu_element($CanvasLayer/marginContainerMenu/MainMenuContainer/container/VBoxContainer/bPlay, "scale", Vector2(1.2,1.2),1)
	tween_menu_element_scale($CanvasLayer/marginContainerMenu/MainMenuContainer/container/VBoxContainer/Control/bPlay, "scale", Vector2(1.1,1.1),0.1)


func _on_b_play_mouse_exited() -> void:
	tween_menu_element_scale($CanvasLayer/marginContainerMenu/MainMenuContainer/container/VBoxContainer/Control/bPlay, "scale", Vector2(1.0,1.0),0.1)


func _on_b_how_to_mouse_entered() -> void:
	tween_menu_element_scale($CanvasLayer/marginContainerMenu/MainMenuContainer/container/VBoxContainer/Control2/bHowTo, "scale", Vector2(1.1,1.1),0.1)


func _on_b_how_to_mouse_exited() -> void:
	tween_menu_element_scale($CanvasLayer/marginContainerMenu/MainMenuContainer/container/VBoxContainer/Control2/bHowTo, "scale", Vector2(1.0,1.0),0.1)


func _on_b_options_mouse_entered() -> void:
	tween_menu_element_scale($CanvasLayer/marginContainerMenu/MainMenuContainer/container/VBoxContainer/Control3/bOptions, "scale", Vector2(1.1,1.1),0.1)


func _on_b_options_mouse_exited() -> void:
	tween_menu_element_scale($CanvasLayer/marginContainerMenu/MainMenuContainer/container/VBoxContainer/Control3/bOptions, "scale", Vector2(1.0,1.0),0.1)


func _on_b_quit_mouse_entered() -> void:
	tween_menu_element_scale($CanvasLayer/marginContainerMenu/MainMenuContainer/container/VBoxContainer/Control4/bQuit, "scale", Vector2(1.1,1.1),0.1)


func _on_b_quit_mouse_exited() -> void:
	tween_menu_element_scale($CanvasLayer/marginContainerMenu/MainMenuContainer/container/VBoxContainer/Control4/bQuit, "scale", Vector2(1.0,1.0),0.1)

func _on_sfx_slider_value_changed(value:float) -> void:
	$CanvasLayer/marginContainerMenu/containerOptions/VBoxContainer/HBoxContainer2/SfxVal.text = str(int(value))
	Globals.sfx_volume = int(value)

func _on_music_slider_value_changed(value:float) -> void:
	$CanvasLayer/marginContainerMenu/containerOptions/VBoxContainer/HBoxContainer/MusicVal.text = str(int(value))
	Globals.music_volume = int(value)

func _on_animation_player_animation_finished(anim_name:StringName) -> void:
	if(anim_name == "transition"):
		get_tree().change_scene_to_file("res://Scenes/game_loop.tscn")
