extends Node2D

class_name PowerUp

enum type {Shield, Double_shot, Triple_shot, Extra_life}
@export var powerup_type: type = type.Shield
@export var time_alive: int = 10

func _ready() -> void:
	set_powerup_look()
	$Timer.start(time_alive)
	
#We'll change this later to change the psrite for the powerup
func set_powerup_look():
	match powerup_type:
		type.Shield:
			$Sprite2D.self_modulate = Color(1.0, 0.0, 0.0)
		type.Double_shot:
			$Sprite2D.self_modulate = Color(0.0, 0.23529412, 1.0)
		type.Triple_shot:
			$Sprite2D.self_modulate = Color(1.0, 0.67058825, 0.0)
		type.Extra_life:
			$Sprite2D.self_modulate = Color(0.39215687, 1.0, 0.0)

func _on_timer_timeout() -> void:
	queue_free()

func _on_pickup_component_picked_up(body: PlayerController) -> void:
	if(body is PlayerController):
		body.add_power_up(powerup_type)
		queue_free()
