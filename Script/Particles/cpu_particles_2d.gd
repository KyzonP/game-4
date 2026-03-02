extends CPUParticles2D

func _on_finished():
	queue_free()

func reset():
	queue_free()
