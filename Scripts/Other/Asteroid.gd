extends Node2D

enum Sizes{SMALL, MEDIUM, BIG}
@export var size: int = Sizes.SMALL
@export var speed: int = 100
@export var rotation_speed := 0.7
@export var point_value: int = 10

@export var min_speed: int = 10
@export var max_speed: int = 200

@export var min_rot_dir: float = -1
@export var max_rot_dir: float = 1

@export var min_rot_speed: float = 0
@export var max_rot_speed: float = 1

func _ready() -> void:
	speed = randi_range(min_speed, max_speed)
	var rotation_speed_dir = randf_range(min_rot_dir, max_rot_dir)
	rotation_speed = randf_range(min_rot_speed, max_rot_speed) * rotation_speed_dir
	#rotation_degrees = -90

func _process(delta: float) -> void:
	if(Globals.current_state == Globals.State.PLAYING):
		global_position += transform.x * speed * delta
		$Sprite2D.rotate(rotation_speed * delta)
		
func fracture():
	match size:
		Sizes.BIG:
			for i in range(2):
				var instance: Node2D = Globals.get_asteroid(1).instantiate()
				get_tree().root.get_child(1).call_deferred("add_child", instance)
				instance.global_position = global_position
				instance.rotate(randi_range(0,360))
		Sizes.MEDIUM:
			for i in range(3):
				var instance: Node2D = Globals.get_asteroid(0).instantiate()
				get_tree().root.get_child(1).call_deferred("add_child", instance)
				instance.position = position
				instance.rotate(randi_range(0,360))
		

#TODO: Change it so the player can collide with the asteroid
func _on_body_entered(body:Node2D) -> void:
	if body.name == "Player":
		#EventBus.player_hit.emit()
		pass


func _on_health_component_died() -> void:
	EventBus.add_points.emit(point_value)
	fracture()
	queue_free()

func _on_visible_on_screen_notifier_2d_screen_exited() -> void:
	#print("Asteroid gone")
	queue_free()
