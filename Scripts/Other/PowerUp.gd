extends Node2D

class_name PowerUp

enum type {Shield, Double_shot, Triple_shot, Extra_life}
@export var powerup_type: type = type.Shield
@export var time_alive: int = 10

@export var shield_img: Texture
@export var extra_life_img: Texture
@export var shot2_img: Texture
@export var shot3_img: Texture

func _ready() -> void:
	if shield_img == null:
		printerr("Missing shield texture")
	set_powerup_look()
	$Timer.start(time_alive)
	
#We'll change this later to change the psrite for the powerup
func set_powerup_look():
	match powerup_type:
		type.Shield:
			$Sprite2D.texture = shield_img
		type.Double_shot:
			$Sprite2D.texture = shot2_img
		type.Triple_shot:
			$Sprite2D.texture = shot3_img
		type.Extra_life:
			$Sprite2D.texture = extra_life_img

func _on_timer_timeout() -> void:
	queue_free()

func _on_pickup_component_picked_up(body: PlayerController) -> void:
	if(body is PlayerController):
		body.add_power_up(powerup_type)
		queue_free()
