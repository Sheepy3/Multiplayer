extends Control

var port:int = 0
var ip:String = "0"
var username:String

func _ready() -> void:
	multiplayer.connected_to_server.connect(_connected)

func _on_host_pressed() -> void:
	port = int ($Panel/VBoxContainer/PortInput.get_text())
	ip = String($Panel/VBoxContainer/IPInput.get_text())
	username = $Panel/VBoxContainer/UsernameInput.get_text()
	#print(username)
	MultiplayerManager.become_host()
	MultiplayerManager.passusername(username, 1) #signal only emittted on client, must manually call for server
	$".".hide()

func _on_join_pressed() -> void:
	port = int($Panel/VBoxContainer/PortInput.get_text())
	ip = $Panel/VBoxContainer/IPInput.get_text()
	username = $Panel/VBoxContainer/UsernameInput.get_text()
	MultiplayerManager.join_game()
	pass # Replace with function body.

func _connected() -> void:
	MultiplayerManager.passusername.rpc(username,multiplayer.get_unique_id())
	$".".hide()
