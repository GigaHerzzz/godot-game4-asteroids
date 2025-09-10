extends Area2D
class_name PickupComponent

signal picked_up

func _on_area_entered(area:Area2D) -> void:
	if area is GrabComponent:
		picked_up.emit(area.get_parent())
