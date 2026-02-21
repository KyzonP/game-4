extends Area2D

@export var speed = 140

var lifespan = 2.7
var lifeTimer = 0.0

var offSet = 25

func _physics_process(delta):
	position += transform.x * speed * delta

	lifeTimer += delta
	if lifeTimer >= lifespan:
		reset()

func reset():
	queue_free()


func _on_body_entered(body):
	if body.is_in_group("player"):
		body.destroy()
		reset()
	elif body.is_in_group("bullet"):
		print("bullet")
		reset()
