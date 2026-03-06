extends Node2D

@export var PlayerScene : PackedScene

@onready var screen_size = get_viewport_rect().size

var player1Score = -1
var player2Score = -1

var player1Id : String
var player2Id : String

var player1Name : String
var player2Name: String

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
					$Player1Name.text = str(GameManager.Players[i].name)
					currentPlayer.bulletAmount = $ControlsL
					currentPlayer.get_node("AnimatedSprite2D").animation = "1"
				elif index == 1:
					player2Id = currentPlayer.name
					$Player2Name.text = "[right]" + str(GameManager.Players[i].name)
					currentPlayer.bulletAmount = $ControlsR
					currentPlayer.get_node("AnimatedSprite2D").animation = "2"
		
		index += 1
		
@rpc("any_peer", "call_local")
func reset(defeatedPlayer, tie):
	
	if tie:
		pass
	else:
		if defeatedPlayer == player2Id:
			player1Score += 1
			$Player1Score.text = "[center]" + str(player1Score)
		elif defeatedPlayer == player1Id:
			player2Score += 1
			$Player2Score.text = "[center]" + str(player2Score)
		
	
	
	get_tree().call_group("reset", "reset")
	
# Screen wrapping
func _on_hole_body_exited(body):
	body.global_position *= -1
	
# If player enters centre, reset with that player losing - if a bullet, destroy it
func _on_center_body_entered(body):
	if body.is_in_group("player"):
		reset(body.name, false)
	elif body.is_in_group("bullet"):
		body.reset()
