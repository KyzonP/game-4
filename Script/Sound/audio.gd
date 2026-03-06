extends Node

var whirlpoolVolume = -30.0
var whirlpoolVolumeMax = 0.0

func _input(event):
	if event.is_action_pressed("mute"):
		var master_bus = AudioServer.get_bus_index("Master")
		var is_muted = AudioServer.is_bus_mute(master_bus)
		AudioServer.set_bus_mute(0, !is_muted)
