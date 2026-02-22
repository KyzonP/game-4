extends Node2D

@export var player : CharacterBody2D

func _physics_process(delta):
	position = player.position * -1.5
