extends Control

@export var Address = "127.0.0.1"
@export var port = 8910

var peer

func _ready():
	multiplayer.peer_connected.connect(peer_connected)
	multiplayer.peer_disconnected.connect(peer_disconnected)
	
	multiplayer.connected_to_server.connect(connected_to_server)
	multiplayer.connection_failed.connect(connection_failed)

# Called on the server and clients when someone connects
func peer_connected(id):
	print("Player Connected " + str(id))
	
# Called on the server and clients when someone disconnects
func peer_disconnected(id):
	print("Player Disconnected " + str(id))
	GameManager.Players.erase(id)
	var players = get_tree().get_nodes_in_group("player")
	for i in players:
		if i.name == str(id):
			i.queue_free()
	
# Called only from clients
func connected_to_server():
	print("Connected to Server")
	sendPlayerInformation.rpc_id(1, $LineEdit.text, multiplayer.get_unique_id())
	
# Called only from clients
func connection_failed():
	print("Couldn't Connect!")
	
@rpc("any_peer")
func sendPlayerInformation(name, id):
	if !GameManager.Players.has(id):
		GameManager.Players[id] = {
			"name": name,
			"id":id,
			"score":0
		}
	
	if multiplayer.is_server():
		for i in GameManager.Players:
			sendPlayerInformation.rpc(GameManager.Players[i].name, i)

@rpc("any_peer", "call_local")	
func StartGame():
	var scene = load("res://Scenes/Multiplayer/MultiplayerTest.tscn").instantiate()
	get_tree().root.add_child(scene)
	
	self.hide()

func _on_host_button_down():
	# Modified to test websocket
	peer = WebSocketMultiplayerPeer.new()
	var error = peer.create_server(port)
	if error != OK:
		print("Cannot Host:" + str(error))
		return
	
	# Removed to test websocket
	#peer.get_host().compress(ENetConnection.COMPRESS_RANGE_CODER)
	
	multiplayer.set_multiplayer_peer(peer)
	print("Waiting for Players . . .")
	sendPlayerInformation($LineEdit.text, multiplayer.get_unique_id())

func _on_join_button_down():
	# Modified to test websocket
	peer = WebSocketMultiplayerPeer.new()
	
	# Modified to test websocket
	peer.create_client("wss://" + Address + ":" + str(port))
	
	# Removed to test websocket
	#peer.get_host().compress(ENetConnection.COMPRESS_RANGE_CODER)
	
	multiplayer.set_multiplayer_peer(peer)

func _on_start_game_button_down():
	StartGame.rpc()
