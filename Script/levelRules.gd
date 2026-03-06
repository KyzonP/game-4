extends Node2D

# test

@onready var screen_size = get_viewport_rect().size

var player1Score = 0
var player2Score = 0

var matchOver = false

# Screen wrapping
func _on_hole_body_exited(body):
	body.global_position *= -1

func reset(defeatedPlayer):
	if !matchOver:
		if defeatedPlayer == 2 || defeatedPlayer == 3:
			player1Score += 1
			$Player1Score.text = "[center]" + str(player1Score)
		elif defeatedPlayer == 1:
			player2Score += 1
			$Player2Score.text = "[center]" + str(player2Score)
			
		matchOver = true
		
		get_tree().call_group("freeze", "freeze")
		
		await get_tree().create_timer(2).timeout
		
		get_tree().call_group("reset", "reset")
		
		matchOver = false

# If player enters centre, reset with that player losing - if a bullet, destroy it
func _on_center_body_entered(body):
	if body.is_in_group("player"):
		reset(body.player)
		body.explode()
	elif body.is_in_group("bullet"):
		body.reset()
