extends Area2D

enum Sizes{SMALL, MEDIUM, BIG}
@export var size: int = Sizes.SMALL
@export var asteroid_speed: int = 100
@export var rotation_speed := 0.7

@export var asteroid_small: PackedScene = preload("res://Scenes/entities/asteroid_small_obj.tscn")
@export var asteroid_medium: PackedScene = preload("res://Scenes/entities/asteroid_med_obj.tscn")
@export var asteroid_large: PackedScene = preload("res://Scenes/entities/asteroid_big_obj.tscn")

func _process(delta: float) -> void:
	if(Globals.current_state == Globals.State.PLAYING):
		position += transform.y * asteroid_speed * delta

		$Sprite2D.rotate(rotation_speed * delta)

func _on_area_entered(area:Area2D) -> void:
	if(area.is_in_group("bullet")):
		fracture()
		queue_free()
		
func fracture():
	size = size -1
	if(size > 1):
		for i in range(size):
			#Finish this to spawn new asteroids if it is bigger than small
			pass
		
