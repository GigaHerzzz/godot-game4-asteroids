extends Area2D

@export var bullet_speed := 1000


func _physics_process(delta):
	if(Globals.current_state == Globals.State.PLAYING):
		position += transform.y * bullet_speed * delta
		
	
func _on_area_entered(area: Area2D) -> void:
	if area.is_in_group("destroy"):
		queue_free()

func _on_body_entered(body:Node2D) -> void:
	if(body.name == "Player" and is_in_group("enemyBullet")):
		EventBus.player_hit.emit()
		queue_free()
