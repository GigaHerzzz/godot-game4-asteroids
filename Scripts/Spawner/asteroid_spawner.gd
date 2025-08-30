extends Node2D

@export var spawn_time_base: int = 5
@export var spawning_vertical: bool = false

func _ready() -> void:
	$SpawnTimer.start(spawn_time_base)

func _on_spawn_timer_timeout() -> void:
	var rand_num = randi_range(0,2)
	var instance: Area2D = Globals.get_asteroid(rand_num).instantiate()
	var window_size = DisplayServer.window_get_size()
	add_child(instance)
	instance.add_to_score.connect($"..".add_points)
	instance.player_hit.connect($"..".player_hit)
	
	if(spawning_vertical):
		var pos_x = randi_range(0, window_size.x)
		var spawn_point = Vector2(pos_x, global_position.y)
		#print("Asteroid spawn location: %s" % str(spawn_point))
		instance.global_position = spawn_point
	else:
		var pos_y = randi_range(0, window_size.y)
		var spawn_point = Vector2(global_position.x, pos_y)
		#print("Asteroid spawn location: %s" % str(spawn_point))
		instance.global_position = spawn_point
	
	instance.look_at($"../Player".global_position)
	$SpawnTimer.start(spawn_time_base)
