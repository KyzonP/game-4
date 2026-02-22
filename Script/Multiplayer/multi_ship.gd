extends CharacterBody2D

@export var speed = 70.0

@export var friction = 0.1
@export var acceleration = 0.1

@export var rotSpeed = 1.0

@export var player : int
@export var startPos : Vector2
@export var startRot : float

var bullet = preload("res://Scenes/Bullet.tscn")

var bullets = 3
var bulletReloadTimer = 0.0
var bulletReloadMax = 1.0

func _ready():

	$MultiplayerSynchronizer.set_multiplayer_authority(str(name).to_int())

func get_vertical_input():
	var input = Vector2()
	
	if Input.is_action_pressed("move_up"):
		input.y -= 1
	if Input.is_action_pressed("move_down"):
		input.y +=1
		
	return input
	
func get_rotational_input():
	var rotDirection
		
	rotDirection = Input.get_axis("move_left", "move_right")

	
	return rotDirection

func _physics_process(delta):
	if $MultiplayerSynchronizer.get_multiplayer_authority() == multiplayer.get_unique_id():
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
		

		if Input.is_action_just_pressed("fire"):
			shoot.rpc()
			
		if bullets < 3:
			bulletReloadTimer += delta
			
			if bulletReloadTimer >= bulletReloadMax:
				bullets += 1
				bulletReloadTimer = 0

@rpc("any_peer", "call_local")
func reset():
	velocity = Vector2.ZERO
	global_position = startPos
	rotation = deg_to_rad(startRot)
	
	bullets = 3
	bulletReloadTimer = 0
	
# Fire a bullet if bullets are greater than 0 - logic for checking bullet count is here to cover AI use
@rpc("any_peer", "call_local")
func shoot():
	if bullets > 0:
		var bullet = bullet.instantiate()
		get_parent().add_child(bullet)
		bullet.global_position = self.global_position
		
		
		bullet.rotation = self.rotation
		bullet.position += bullet.transform.x * bullet.offSet
		
		bullets -= 1
	
# Pass on player number to parent, to give point and begin reset
func destroy():
	get_parent().reset(self, false)

# If colliding with another player, level resets and nobody gets a point
func _on_area_2d_body_entered(body):
	if body.is_in_group("player"):
		get_parent().reset(self, true)
