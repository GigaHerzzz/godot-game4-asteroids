extends Node2D

class_name EnemyShip

@export var move_speed:int = 100
@export var move_vector: Vector2

@export var shoot_cooldown:int = 2

@export var player:PlayerController

@export var projectile: PackedScene = preload("res://Scenes/entities/enemy_projectile.tscn")

func _ready() -> void:
	#move_vector = Vector2(randf_range(-1,1), randf_range(-1,1))
	$TimerShootCooldown.start(shoot_cooldown)
	
func _process(delta: float) -> void:
	if(Globals.current_state == Globals.State.PLAYING):
		if(move_vector != Vector2.ZERO):
			position += move_vector * move_speed * delta
			$EnemyCursor.look_at(player.global_position)
			$EnemyCursor.rotate(-PI/2)
	
func add_player(player_ref: PlayerController):
	player = player_ref
	move_vector = (player.global_position - global_position).normalized()

func shoot():
	var proj:Area2D = projectile.instantiate()
	get_tree().root.get_child(1).add_child(proj)
	proj.transform = $EnemyCursor.global_transform

func _on_timer_shoot_cooldown_timeout() -> void:
	shoot()
	$TimerShootCooldown.start(shoot_cooldown)


func _on_area_2d_area_entered(area:Area2D) -> void:
	if area.is_in_group("destroy"):
		#print("Enemy down")
		queue_free()


func _on_area_2d_body_entered(body: Node2D) -> void:
	if(body == player):
		var ent: GameController = get_parent() as GameController
		ent.player_hit()
		queue_free()
