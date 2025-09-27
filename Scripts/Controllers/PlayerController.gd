extends CharacterBody2D

class_name PlayerController

enum shooting_mode {Single, Dobule, Triple}

@export var acceleration: float = 20
@export var drag: int = 10
@export var max_acceleration: float = 400
@export var current_acceleration: float = 0
@export var respawn_position: Vector2 = Vector2(0,0)
@export var respawn_time: int = 3
@export var imunity_time: int = 5
@export var healing_amount: int = 10

@export var rotation_acc: int = 150

@export var Bullet : PackedScene

@export var can_move := true

@export var shoot_cooldown := 0.2
@export var is_shielded: bool = false
@export var can_shoot: bool = true
@export var gun: int = shooting_mode.Single

@export var shield_time: int = 30
@export var gun_time: int = 30

var spacePrx: SpaceParallax

signal add_life

func _ready() -> void:
	#EventBus.player_hit.connect(got_hit)
	spacePrx = get_parent().find_child("SpaceParallax")
	EventBus.game_over.connect(game_over)

func _process(delta: float) -> void:
	if(Globals.current_state == Globals.State.PLAYING):
		if(Input.is_action_pressed("fire") and can_shoot):
			shoot()

func _physics_process(delta: float) -> void:
	if(Globals.current_state == Globals.State.PLAYING and can_move):
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
		if(spacePrx != null):
			spacePrx.set_move_angle(velocity.angle())
			var acc_factor = velocity.length()/max_acceleration
			spacePrx.set_acc_factor(acc_factor)
		move_and_slide()
		
		check_for_wrapping()

func shoot():
	match gun:
		shooting_mode.Single:
			var b = Bullet.instantiate()
			get_tree().root.get_child(1).add_child(b)
			b.transform = $ShootPoint.global_transform
			can_shoot = false
			$TimerShootColdown.start(shoot_cooldown)
		shooting_mode.Dobule:
			var b1 = Bullet.instantiate()
			var b2 = Bullet.instantiate()
			get_tree().root.get_child(1).add_child(b1)
			get_tree().root.get_child(1).add_child(b2)
			b1.transform = $ShootPoint2.global_transform
			b2.transform = $ShootPoint3.global_transform
			can_shoot = false
			$TimerShootColdown.start(shoot_cooldown)
		shooting_mode.Triple:
			var b1 = Bullet.instantiate()
			var b2 = Bullet.instantiate()
			var b3 = Bullet.instantiate()
			get_tree().root.get_child(1).add_child(b1)
			get_tree().root.get_child(1).add_child(b2)
			get_tree().root.get_child(1).add_child(b3)
			b1.transform = $ShootPoint.global_transform
			b2.transform = $ShootPoint2.global_transform
			b3.transform = $ShootPoint3.global_transform
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


#Player got hit, should dissapear and respawn in the middle after a vouple of seconds
func got_hit() -> void:
	#$HurtboxComponent.set_deferred("disabled", true)
	EventBus.player_hit.emit()
	$HurtboxComponent.toggle_disabled(true)
	can_shoot = false
	can_move = false
	$TimerShootColdown.stop()
	$TimerGunMode.stop()
	gun = shooting_mode.Single
	velocity = Vector2.ZERO
	visible = false
	global_position = respawn_position
	$TimerRespawn.start(respawn_time)
	

func _on_timer_respawn_timeout() -> void:
	visible = true
	$AnimationPlayer.play("respawn")
	can_move = true
	$TimerImunity.start(imunity_time)


func _on_timer_imunity_timeout() -> void:
	$HurtboxComponent.toggle_disabled(false)
	can_shoot = true


func game_over() -> void:
	$HurtboxComponent.toggle_disabled(false)
	can_shoot = false
	can_move = false
	velocity = Vector2.ZERO
	visible = false
	global_position = respawn_position


func add_power_up(type: int):
	match type:
		PowerUp.type.Shield:
			is_shielded = true
			$SpriteShield.visible = true
			$TimerShield.start(shield_time)
		PowerUp.type.Double_shot:
			$TimerGunMode.start(gun_time)
			if(gun <= shooting_mode.Dobule):
				gun = shooting_mode.Dobule
		PowerUp.type.Triple_shot:
			$TimerGunMode.start(gun_time)
			gun = shooting_mode.Triple
		PowerUp.type.Extra_life:
			add_life.emit()
			$HealthComponent.add_health(healing_amount)
			

func disable_shield():
	is_shielded = false
	$SpriteShield.visible = false
	$TimerShield.stop()
	
func _on_timer_shield_timeout() -> void:
	disable_shield()


func _on_timer_gun_mode_timeout() -> void:
	gun = shooting_mode.Single

func _on_health_component_died() -> void:
	got_hit()


func _on_health_component_hurt() -> void:
	print("Player Got hit")
	got_hit()
