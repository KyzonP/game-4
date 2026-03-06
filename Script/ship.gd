extends CharacterBody2D

@export var speed = 70.0

@export var friction = 0.1
@export var acceleration = 0.1

@export var rotSpeed = 1.0

@export var player : int
@export var startPos : Vector2
@export var startRot : float

@export var bulletAmount : Sprite2D

var bullet = preload("res://Scenes/Bullet.tscn")

var bullets = 3
var bulletReloadTimer = 0.0
var bulletReloadMax = 1.0

var frozen = false

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
	if !frozen:
		velocity = get_real_velocity()
		
		if player <=2:
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
		elif player == 3:
			# AI Rotation
			rotation = $AILogic.calculateRotation(rotation, rotSpeed, delta)
			
			# AI velocity
			velocity = $AILogic.calculateVelocity(velocity, speed, acceleration, friction)
			
			# Check shooting
			if $AILogic.checkShooting():
				shoot()
			
		velocity += get_gravity()

		move_and_slide()
		

		if Input.is_action_just_pressed("fire") and player == 1:
			shoot()
		if Input.is_action_just_pressed("fire_p2") and player == 2:
			shoot()
			
		if bullets < 3:
			bulletReloadTimer += delta
			
			if bulletReloadTimer >= bulletReloadMax:
				bullets += 1
				bulletReloadTimer = 0
				
				### UI ###
				updateUI()

func reset():
	
	frozen = false
	velocity = Vector2.ZERO
	global_position = startPos
	rotation = deg_to_rad(startRot)
	
	bullets = 3
	bulletReloadTimer = 0
	
	### UI ###
	updateUI()
	
	### Visuals ###
	$Explosion.emitting = false
	$Explosion.hide()
	
	
# Fire a bullet if bullets are greater than 0 - logic for checking bullet count is here to cover AI use
func shoot():
	if bullets > 0:
		var bullet = bullet.instantiate()
		get_parent().add_child(bullet)
		bullet.global_position = self.global_position
		
		
		bullet.rotation = self.rotation
		bullet.position += bullet.transform.x * bullet.offSet
		
		bullets -= 1
		
		if $FireParticles.emitting:
			$FireParticles.restart()
		else:
			$FireParticles.emitting = true
			
		### UI ###
		updateUI()
		
				
		### AUDIO ###
		$Fire.playSound()
		
func freeze():
	frozen = true
	
# Pass on player number to parent, to give point and begin reset
func destroy():
	### Sending message to level to reset ###
	get_parent().reset(player)
	
func explode():
	### Visuals - hide sprite and activate explosion particles ###
	#$AnimatedSprite2D.visible = false
	$Explosion.show()
	$Explosion.emitting = true
	
	$ExplosionSound.play()
	await get_tree().create_timer(0.15).timeout
	$ExplosionSound.play()
	await get_tree().create_timer(0.15).timeout
	$ExplosionSound.play()
	await get_tree().create_timer(0.15).timeout
	$ExplosionSound.play()
	await get_tree().create_timer(0.15).timeout
	$ExplosionSound.play()
	await get_tree().create_timer(0.15).timeout
	

# If colliding with another player, level resets and nobody gets a point
func _on_area_2d_body_entered(body):
	if body.is_in_group("player") and !body == self:
		### Visuals ###
		explode()
		body.explode()
		
		### Send message to level to reset
		get_parent().reset(0)
		
func updateUI():
	if bulletAmount:
		bulletAmount.bulletChange(bullets)
