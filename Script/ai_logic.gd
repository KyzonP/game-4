extends Node2D

@export var searchcast : ShapeCast2D
@export var firecast : ShapeCast2D
@export var centercast : ShapeCast2D
@export var wideCentercast : ShapeCast2D
@export var rearcast : ShapeCast2D

@export var rotateMod = 1


func calculateVelocity(velocity, speed, acceleration, friction):
	if wideCentercast.is_colliding():
		if centercast.is_colliding():
			velocity = velocity.lerp(Vector2.ZERO, friction)
		else:
			velocity = velocity.lerp(speed * get_parent().transform.x, acceleration)
			
		return velocity
	
	if searchcast.is_colliding():
		var enemy = searchcast.get_collider(0)
		
		velocity = velocity.lerp(speed * get_parent().transform.x, acceleration)
		
		return velocity
	else:
		velocity = velocity.lerp(speed * get_parent().transform.x, acceleration)
		return velocity
	
func calculateRotation(rotation, speed, delta):
	if wideCentercast.is_colliding():
		var target_angle
		
		if get_parent().position.y > 0:
			target_angle = get_angle_to(Vector2(0,200))
		else:
			target_angle = get_angle_to(Vector2(0,-200))
		
		rotation = lerp_angle(rotation, rotation + target_angle, speed * delta * rotateMod)
		
		return rotation
		
	elif searchcast.is_colliding():
		var enemy = searchcast.get_collider(0)
		var enemyPos = enemy.global_position
		
		var target_angle = get_angle_to(enemyPos)
		
		rotation = lerp_angle(rotation, rotation + target_angle, speed * delta * rotateMod)
		
		return rotation
	elif rearcast.is_colliding():
		var target_angle
		if get_parent().position.y < 0:
			target_angle = get_angle_to(Vector2(0,200))
		else:
			target_angle = get_angle_to(Vector2(0,-200))
			
		rotation = lerp_angle(rotation, rotation + target_angle, speed * delta * rotateMod)
		
		return rotation
	else: 
		return rotation

func checkShooting():
	if firecast.is_colliding():
		print(firecast.get_collider(0))
		if firecast.get_collider(0).is_in_group("player"):
			return true
