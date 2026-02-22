extends Node2D

@export var PlayerScene : PackedScene

@onready var screen_size = get_viewport_rect().size

var player1Score = -1
var player2Score = -1

var player1Id : String
var player2Id : String

func _ready():
	var index = 0
	for i in GameManager.Players:
		var currentPlayer = PlayerScene.instantiate()
		
		currentPlayer.name = str(GameManager.Players[i].id)
		
		add_child(currentPlayer)
		for spawn in get_tree().get_nodes_in_group("PlayerSpawnPoint"):
			if spawn.name == str(index):
				currentPlayer.startPos = spawn.global_position
				currentPlayer.startRot = spawn.startRotation
				
				currentPlayer.reset()
				
				#This is a specific bit of code for this game to streamline things
				if index == 0:
					player1Id = currentPlayer.name
				elif index == 1:
					player2Id = currentPlayer.name
		
		index += 1
		
func reset(defeatedPlayer, tie):
	print(player1Score)
	print(player2Score)
	if tie:
		return
	
	if defeatedPlayer.name == player2Id:
		player1Score += 1
		$Player1Score.text = "[center]" + str(player1Score)
	elif defeatedPlayer.name == player1Id:
		player2Score += 1
		$Player2Score.text = "[center]" + str(player2Score)
		
	
	get_tree().call_group("reset", "reset")
	
# Screen wrapping
func _on_hole_body_exited(body):
	body.global_position *= -1
	
# If player enters centre, reset with that player losing - if a bullet, destroy it
func _on_center_body_entered(body):
	if body.is_in_group("player"):
		reset(body, false)
	elif body.is_in_group("bullet"):
		body.reset()
