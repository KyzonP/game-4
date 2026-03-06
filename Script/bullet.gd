extends Area2D

@export var speed = 140

var lifespan = 2.7
var lifeTimer = 0.0

var offSet = 25

var switched = false

func _physics_process(delta):
	position += transform.x * speed * delta

	lifeTimer += delta
	if lifeTimer >= lifespan:
		$AudioStreamPlayer.play()
		$AudioStreamPlayer.reparent(get_parent())
		reset()
		
		
	# Covering the case when a bullet is fired outside the arena, so it appears on the opposite side
	#if !switched:
		#if global_position.distance_to(Vector2(0,0)) > 260:
			#global_position *= -1
			#switched = true

func reset():
	if $CPUParticles2D:
		$CPUParticles2D.one_shot = true
		$CPUParticles2D.reparent(get_parent())
	
	queue_free()


func _on_body_entered(body):
	if body.is_in_group("player"):
		body.destroy()
		if body.has_method("explode"):
			body.explode()
		reset()
	elif body.is_in_group("bullet"):
		reset()
