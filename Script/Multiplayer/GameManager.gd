extends Node

var Players = {}

func _process(delta):
	if multiplayer.multiplayer_peer:
		multiplayer.multiplayer_peer.poll()
