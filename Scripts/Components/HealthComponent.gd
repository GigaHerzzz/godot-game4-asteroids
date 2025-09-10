extends Node2D
class_name HealthComponent

signal died
signal hurt

@export var max_health: int = 10
var health: int = 0

func _ready() -> void:
	health = max_health
	
func add_health(healing: int):
	health += healing

func remove_health(dmg: int):
	health -= dmg
	if(health <= 0):
		died.emit()
	else:
		hurt.emit()