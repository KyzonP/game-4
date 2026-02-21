extends CharacterBody2D

@export var speed = 70.0

@export var friction = 0.1
@export var acceleration = 0.1

@export var rotSpeed = 1.0

@export var player : int
@export var startPos : Vector2
@export var startRot : float

var bullet = preload("res://Scenes/Bullet.tscn")

func _ready():
	reset()

func get_vertical_input():
	var input = Vector2()
	
	if player == 1:
		if Input.is_action_pressed("move_up"):
			input.y -= 1
		if Input.is_action_pressed("move_down"):
			input.y +=1
	elif player == 2:
		if Input.is_action_pressed("move_up_p2"):
			input.y -= 1
		if Input.is_action_pressed("move_down_p2"):
			input.y +=1
		
	return input
	
func get_rotational_input():
	var rotDirection
	if player == 1:
		rotDirection = Input.get_axis("move_left", "move_right")
	elif player == 2:
		rotDirection = Input.get_axis("move_left_p2", "move_right_p2")
	
	return rotDirection

func _physics_process(delta):
	velocity = get_real_velocity()
	
	var rotDirection = get_rotational_input()
	if rotDirection:
		rotation += rotDirection * rotSpeed * delta
	
	var direction = get_vertical_input()
	
	if direction.length() > 0:
		if direction.y < 0:
			velocity = velocity.lerp(speed * transform.x, acceleration)
		else:
			velocity = velocity.lerp(Vector2.ZERO, friction)
	else:
		velocity = velocity.lerp(Vector2.ZERO, friction)
		
	velocity += get_gravity()

	move_and_slide()
	
	if Input.is_action_just_pressed("fire") and player == 1:
		shoot()
	if Input.is_action_just_pressed("fire_p2") and player == 2:
		shoot()

func reset():
	velocity = Vector2.ZERO
	global_position = startPos
	rotation = deg_to_rad(startRot)
	
func shoot():
	var bullet = bullet.instantiate()
	get_parent().add_child(bullet)
	bullet.global_position = self.global_position
	
	
	bullet.rotation = self.rotation
	bullet.position += bullet.transform.x * bullet.offSet
	
# Pass on player number to parent, to give point and begin reset
func destroy():
	get_parent().reset(player)

# If colliding with another player, level resets and nobody gets a point
func _on_area_2d_body_entered(body):
	if body.is_in_group("player"):
		get_parent().reset(0)
