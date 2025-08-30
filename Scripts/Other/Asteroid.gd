extends Area2D

enum Sizes{SMALL, MEDIUM, BIG}
@export var size: int = Sizes.SMALL
@export var speed: int = 100
@export var rotation_speed := 0.7

@export var min_speed: int = 10
@export var max_speed: int = 200

@export var min_rot_dir: float = -1
@export var max_rot_dir: float = 1

@export var min_rot_speed: float = 0
@export var max_rot_speed: float = 1

signal add_to_score
signal player_hit

func _ready() -> void:
	speed = randi_range(min_speed, max_speed)
	var rotation_speed_dir = randf_range(min_rot_dir, max_rot_dir)
	rotation_speed = randf_range(min_rot_speed, max_rot_speed) * rotation_speed_dir
	#rotation_degrees = -90

func _process(delta: float) -> void:
	if(Globals.current_state == Globals.State.PLAYING):
		global_position += transform.x * speed * delta

		$Sprite2D.rotate(rotation_speed * delta)

func _on_area_entered(area:Area2D) -> void:
	if(area.is_in_group("bullet")):
		add_to_score.emit()
		fracture()
		area.queue_free()
		queue_free()
	if (area.is_in_group("destroy")):
		#print("Asteroid left area")
		queue_free()
		
func fracture():
	match size:
		Sizes.BIG:
			for i in range(2):
				var instance: Area2D = Globals.get_asteroid(1).instantiate()
				get_tree().root.get_child(1).call_deferred("add_child", instance)
				instance.add_to_score.connect($"/root/GameLoop".add_points)
				instance.player_hit.connect($"/root/GameLoop".player_hit)
				instance.global_position = global_position
				instance.rotate(randi_range(0,360))
				#print("Added smaller asteroid at %s" % instance.global_position)
		Sizes.MEDIUM:
			for i in range(3):
				var instance: Area2D = Globals.get_asteroid(0).instantiate()
				get_tree().root.get_child(1).call_deferred("add_child", instance)
				instance.add_to_score.connect($"/root/GameLoop".add_points)
				instance.player_hit.connect($"/root/GameLoop".player_hit)
				instance.position = position
				instance.rotate(randi_range(0,360))
		


func _on_body_entered(body:Node2D) -> void:
	if body.name == "Player":
		player_hit.emit()
