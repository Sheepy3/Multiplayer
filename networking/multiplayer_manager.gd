extends Node

@onready var MultiplayerHud = get_tree().get_current_scene().get_node("MultiplayerHud")
@onready var server_port
@onready var server_IP
var multiplayer_scene = preload("res://player/player.tscn") #scene that represents player character. 
var _players_spawn_node

func become_host(username) -> void:
	server_IP = MultiplayerHud.ip
	server_port = MultiplayerHud.port
	_players_spawn_node = get_tree().get_current_scene().get_node("SpawnPoint")
	var server_peer = ENetMultiplayerPeer.new() 
	server_peer.create_server(server_port) #make le server
	multiplayer.multiplayer_peer = server_peer #sets host to server 
	
	#call function when player connects or disconnects. does not run when host creates server.
	multiplayer.peer_connected.connect(_add_player_to_game)
	multiplayer.peer_disconnected.connect(_del_player)
	_add_player_to_game(1)
	
func join_game():
	server_IP = MultiplayerHud.ip
	server_port = MultiplayerHud.port
	var client_peer = ENetMultiplayerPeer.new()
	client_peer.create_client(str(server_IP),server_port)
	multiplayer.multiplayer_peer = client_peer
	pass

func _add_player_to_game(id: int):
	#print("Player %s joined the game!" % id)
	var player_to_add = multiplayer_scene.instantiate()
	 #instantiate a new player
	player_to_add.player_id = id
	player_to_add.name = str(id) #gives all joining players a placeholder name while awaiting RPC with username
	_players_spawn_node.add_child(player_to_add,true)
	
	var allplayers = _players_spawn_node.get_children()
	for nodes in allplayers:
		if nodes.get_node("Label3D").text == "default": # only applies placeholder name if name isnt set
			nodes.get_node("Label3D").text = nodes.name 
		pass
	
func _del_player(id: int):
	pass

@rpc("any_peer", "call_remote","reliable")
func passusername(username, id):
	print("called by" + str(id))
	var allplayers = _players_spawn_node.get_children()
	for nodes in allplayers:
		if nodes.name == str(id):
			print(username)
			#nodes.name = username
			nodes.get_node("Label3D").text = username 
		pass
