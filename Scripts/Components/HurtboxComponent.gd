extends Area2D
class_name HurtboxComponent

@export var healthComponent: HealthComponent
@export var hitMarkerCommponent: HitMarkerComponent

func _ready() -> void:
	if healthComponent == null:
		printerr("%s is missing HealthComponent!" % name)
		
func toggle_disabled(is_disabled: bool):
	get_child(0).set_deferred("disabled", is_disabled)

func _on_area_entered(area:Area2D) -> void:
	if area is HitboxComponent:
		if hitMarkerCommponent != null:
			hitMarkerCommponent.show_marker()
		if healthComponent != null:
			healthComponent.remove_health(area.damage)
		else:
			printerr("Can't perform action! $s is missing HealthComponent!" % name)
