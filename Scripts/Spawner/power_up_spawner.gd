extends Node2D

class_name PowerUpSpawner

var power_up: PackedScene = preload("res://Scenes/entities/power_up.tscn")

var can_spawn_life: bool = false

@export var powerup_time: int = 10

var play_area: Vector2

func _ready() -> void:
	play_area = DisplayServer.window_get_size()
	
func start_spawning():
	print("Started spawning powerups")
	$TimerSpawn.start(powerup_time)

func set_can_spawn_life():
	can_spawn_life = true
	
func spawn_new_powerup(powerup_type: PowerUp.type):
	var powerup = power_up.instantiate() as PowerUp
	var randx = randi_range(0, play_area.x)
	var randy = randi_range(0, play_area.y)
	powerup.powerup_type = powerup_type
	powerup.set_powerup_look()
	add_child(powerup)
	powerup.position = Vector2(randx, randy)
	

func _on_timer_spawn_timeout() -> void:
	var power: int
	if(can_spawn_life):
		print("Spawning extra life")
		power = PowerUp.type.Extra_life
		can_spawn_life = false
	else:
		power = randi_range(0, 2)
	spawn_new_powerup(power)
	$TimerSpawn.start(powerup_time)
