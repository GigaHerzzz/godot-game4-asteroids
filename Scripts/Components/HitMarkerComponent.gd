extends Node2D
class_name HitMarkerComponent

func show_marker():
	var parent = get_parent()
	if(parent != null):
		var tween = get_tree().create_tween()
		tween.tween_property(parent, "modulate:v", 1, 0.25).from(15)
