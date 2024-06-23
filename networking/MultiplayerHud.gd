extends Control

var port:int = 0
var ip = 0
var username:String

func _ready():
	multiplayer.connected_to_server.connect(_connected)

func _on_host_pressed():
	port = int ($Panel/VBoxContainer/PortInput.get_text())
	ip = $Panel/VBoxContainer/IPInput.get_text()
	username = $Panel/VBoxContainer/UsernameInput.get_text()
	#print(username)
	MultiplayerManager.become_host(username)
	MultiplayerManager.passusername(username, 1) #signal only emittted on client, must manually call for server
	$".".hide()

func _on_join_pressed():
	port = int($Panel/VBoxContainer/PortInput.get_text())
	ip = $Panel/VBoxContainer/IPInput.get_text()
	username = $Panel/VBoxContainer/UsernameInput.get_text()
	MultiplayerManager.join_game()
	pass # Replace with function body.

func _connected():
	MultiplayerManager.passusername.rpc(username,multiplayer.get_unique_id())
	$".".hide()
