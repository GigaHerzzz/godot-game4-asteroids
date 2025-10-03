extends Node2D

class_name EnemyShip

@export var move_speed:int = 100
@export var move_vector: Vector2

@export var shoot_cooldown:int = 2

@export var player:PlayerController

@export var projectile: PackedScene = preload("res://Scenes/entities/enemy_projectile.tscn")
@export var effect_explosion: PackedScene

func _ready() -> void:
	#move_vector = Vector2(randf_range(-1,1), randf_range(-1,1))
	$TimerShootCooldown.start(shoot_cooldown)
	
func _process(delta: float) -> void:
	if(Globals.current_state == Globals.State.PLAYING):
		if(move_vector != Vector2.ZERO):
			position += move_vector * move_speed * delta
			$EnemyCursor.look_at(player.global_position)
			$EnemyCursor.rotate(-PI/2)
			$Sprite2D.look_at(player.global_position)
			$Sprite2D.rotate(-PI/2)
	
func add_player(player_ref: PlayerController):
	player = player_ref
	move_vector = (player.global_position - global_position).normalized()

func shoot():
	var proj:Node2D = projectile.instantiate()
	get_tree().root.get_child(1).add_child(proj)
	proj.transform = $EnemyCursor.global_transform

func effect_explode():
	#Particle part
	if(effect_explosion != null):
		var effect :ExplosionEffect = effect_explosion.instantiate()
		effect.position = Vector2.ZERO
		effect.rotation = rotation
		effect.start_particles()
		add_child(effect)
	
	#Tween part
	$Sprite2D.visible = false
	$ExplosionParts.visible = true

	var tween1 = get_tree().create_tween()
	var tween2 = get_tree().create_tween()
	var tween3 = get_tree().create_tween()
	var tween4 = get_tree().create_tween()

	tween2.tween_property($ExplosionParts/ship2, "position", Vector2(-20, -20), 3)
	tween2.parallel().tween_property($ExplosionParts/ship2, "rotation", deg_to_rad(90), 3)
	tween2.parallel().tween_property($ExplosionParts/ship2, "modulate:a", 0, 1).set_delay(2)

	tween3.tween_property($ExplosionParts/ship3, "position", Vector2(+20, -40), 3)
	tween3.parallel().tween_property($ExplosionParts/ship3, "rotation", deg_to_rad(-60), 3)
	tween3.parallel().tween_property($ExplosionParts/ship3, "modulate:a", 0, 1).set_delay(2)

	tween4.tween_property($ExplosionParts/ship4, "position", Vector2(-20, +30), 3)
	tween4.parallel().tween_property($ExplosionParts/ship4, "rotation", deg_to_rad(45), 3)
	tween4.parallel().tween_property($ExplosionParts/ship4, "modulate:a", 0, 1).set_delay(2)

	tween1.tween_property($ExplosionParts/ship1, "position", Vector2(20, 20), 3)
	tween1.parallel().tween_property($ExplosionParts/ship1, "rotation", deg_to_rad(60), 3)
	tween1.parallel().tween_property($ExplosionParts/ship1, "modulate:a", 0, 1).set_delay(2)
	tween1.tween_callback(queue_free)

func _on_timer_shoot_cooldown_timeout() -> void:
	shoot()
	$TimerShootCooldown.start(shoot_cooldown)
	
func _on_health_component_died() -> void:
	$TimerShootCooldown.stop()
	effect_explode()
	#$Sprite2D.visible = false
	#queue_free()

func _on_health_component_hurt() -> void:
	#TODO: flash sprite or something
	pass


func _on_visible_on_screen_notifier_2d_screen_exited() -> void:
	queue_free()
