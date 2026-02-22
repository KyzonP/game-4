extends Node2D

# test

@onready var screen_size = get_viewport_rect().size

var player1Score = 0
var player2Score = 0

# Screen wrapping
func _on_hole_body_exited(body):
	body.global_position *= -1

func reset(defeatedPlayer):
	if defeatedPlayer == 2 || defeatedPlayer == 3:
		player1Score += 1
		$Player1Score.text = "[center]" + str(player1Score)
	elif defeatedPlayer == 1:
		player2Score += 1
		$Player2Score.text = "[center]" + str(player2Score)
	elif defeatedPlayer == 0:
		pass
		
	
	get_tree().call_group("reset", "reset")

# If player enters centre, reset with that player losing - if a bullet, destroy it
func _on_center_body_entered(body):
	if body.is_in_group("player"):
		reset(body.player)
	elif body.is_in_group("bullet"):
		body.reset()
