extends Node2D

class_name EnemyShip

@export var move_speed:int = 100
@export var move_vector: Vector2

@export var shoot_cooldown:int = 2

func _ready() -> void:
	move_vector = Vector2(randf_range(-1,1), randf_range(-1,1))
	
func _process(delta: float) -> void:
	position += move_vector * move_speed * delta

func shoot():
	pass

func _on_timer_shoot_cooldown_timeout() -> void:
	shoot()
	$TimerShootCooldown.start(shoot_cooldown)

#It's not being destroyed, see why
func _on_area_2d_body_entered(body:Node2D) -> void:
	if body.is_in_group("destroy"):
		print("Enemy down")
		#print("bullet_gone")
		queue_free()
