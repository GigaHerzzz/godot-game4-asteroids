extends Node2D
class_name AnimShipExplode

func _on_anim_ship_explode_animation_finished(anim_name:StringName) -> void:
	queue_free()
