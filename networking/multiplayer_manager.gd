extends Node

const server_port = 8080
const server_IP = "127.0.0.1"

var multiplayer_scene = preload("res://player/player.tscn") #scene that represents player character. 
var _players_spawn_node

func become_host():
	
	_players_spawn_node = get_tree().get_current_scene().get_node("SpawnPoint")
	
	var server_peer = ENetMultiplayerPeer.new() 
	server_peer.create_server(server_port) #make le server

	multiplayer.multiplayer_peer = server_peer #sets host to server 
	
	#call function when player connects or disconnects. does not run when host creates server.
	multiplayer.peer_connected.connect(_add_player_to_game)
	multiplayer.peer_disconnected.connect(_del_player)
	_add_player_to_game(1)
func join_game():
	var client_peer = ENetMultiplayerPeer.new()
	client_peer.create_client(server_IP,server_port)
	
	multiplayer.multiplayer_peer = client_peer
	pass

func _add_player_to_game(id: int):
	print("Player %s joined the game!" % id)
	var player_to_add = multiplayer_scene.instantiate() #instantiate a new player
	player_to_add.player_id = id
	player_to_add.name = str(id)
	
	_players_spawn_node.add_child(player_to_add,true)
	#add the new instantiation as a child of the spawnpoint, which the multiplayer spawner can detect.
	pass
	
func _del_player(id: int):
	pass
	
#func _process(delta):
	#%Label.set_text(get_multiplayer_authority())
