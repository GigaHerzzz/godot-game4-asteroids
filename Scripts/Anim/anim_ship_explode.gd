extends AnimationPlayer
class_name AnimShipExplode



func _on_animation_finished(anim_name:StringName) -> void:
	queue_free()
