extends Label


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if %InputSynchronizer.get_multiplayer_authority() == multiplayer.get_unique_id():
		set_text(str(%InputSynchronizer.get_multiplayer_authority()))
		show()
	else:
		hide()
