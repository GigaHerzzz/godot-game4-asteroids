extends Node2D
class_name ExplosionEffect

func set_size(new_size: float):
	$ParticleAsteroidShatter.scale_amount_min = new_size
	$ParticleAsteroidShatter.scale_amount_max = new_size

func start_particles():
	$ParticleAsteroidShatter.emitting = true

func _on_particle_asteroid_shatter_finished() -> void:
	queue_free()
