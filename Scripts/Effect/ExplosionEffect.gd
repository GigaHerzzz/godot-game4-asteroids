extends Node2D
class_name ExplosionEffect

func set_size(new_size: float):
	$ParticleEffect.scale_amount_min = new_size
	$ParticleEffect.scale_amount_max = new_size

func start_particles():
	$ParticleEffect.emitting = true

func _on_particle_asteroid_shatter_finished() -> void:
	queue_free()


func _on_gpu_particles_2d_finished() -> void:
	queue_free()
