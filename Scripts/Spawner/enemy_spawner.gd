extends Node2D

class_name EnemySpawner

@export var enemy_ship_inst: PackedScene = preload("res://Scenes/entities/enemy_ship.tscn")
var play_area: Vector2
@export var extra_distance: int = 10

func _ready():
	play_area = DisplayServer.window_get_size()
	
func spawn_enemy():
	var pos_y = randi_range(-extra_distance, play_area.y + extra_distance)
	var random_dir = randi_range(0,1)
	var pos_x
	if(random_dir > 0):
		pos_x = play_area.x + extra_distance
	else:
		pos_x = -extra_distance
	
	var enemy:EnemyShip = enemy_ship_inst.instantiate()
	get_parent().add_child(enemy)
	enemy.global_position = Vector2(pos_x, pos_y)
	var parent = get_parent() as GameController
	enemy.add_player(parent.find_child("Player"))
	
