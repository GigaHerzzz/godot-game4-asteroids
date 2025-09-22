extends CPUParticles2D
class_name ParticleAppear

func _on_finished() -> void:
	queue_free()

func start_particles():
	emitting = true