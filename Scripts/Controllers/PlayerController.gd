extends CharacterBody2D

@export var acceleration: int = 20
@export var drag: int = 10
@export var max_acceleration: int = 400
@export var current_acceleration: float = 0

@export var rotation_acc: int = 150

@export var Bullet : PackedScene

@export var can_move := false

@export var shoot_cooldown := 0.2
@export var can_shoot = true

func _process(delta: float) -> void:
	if(Globals.current_state == Globals.State.PLAYING):
		if(Input.is_action_pressed("fire")):
			if(can_shoot):
				shoot()

func _physics_process(delta: float) -> void:
	if(Globals.current_state == Globals.State.PLAYING):
		if(Input.is_action_pressed("forward_thrust")):
			velocity += Vector2(0,acceleration).rotated(rotation)
			velocity = velocity.limit_length(max_acceleration)
		else:
			velocity = velocity.move_toward(Vector2.ZERO, 3)

		if(Input.is_action_pressed("tilt_left")):
			rotate(deg_to_rad(-rotation_acc*delta))
		if(Input.is_action_pressed("tilt_right")):
			rotate(deg_to_rad(rotation_acc*delta))

		velocity += Vector2(0, current_acceleration * delta).rotated(rotation_degrees)
		move_and_slide()
		
		check_for_wrapping()

func shoot():
	var b = Bullet.instantiate()
	get_tree().root.add_child(b)
	b.transform = $ShootPoint.global_transform
	can_shoot = false
	$TimerShootColdown.start(shoot_cooldown)

func check_for_wrapping():
	var window_size = DisplayServer.window_get_size()
	var size = $Sprite2D.texture.get_size()
	if(position.x < -size.x/2):
		position.x = window_size.x
	if(position.y <  -size.y/2):
		position.y = window_size.y
	if(position.y > window_size.y + size.y/2):
		position.y = 0
	if(position.x > window_size.x + size.x/2):
		position.x = 0
	

#Signal from game contrller, the player has control of the ship
#Might not be needed if we use the global game_state to controll the players behaviour
func _on_game_loop_play_game() -> void:
	can_move = true


func _on_timer_shoot_coldown_timeout() -> void:
	can_shoot = true
