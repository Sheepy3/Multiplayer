extends MultiplayerSynchronizer

@onready var player = $".."

var input_direction :Vector2

# Called when the node enters the scene tree for the first time.
func _ready():
	if get_multiplayer_authority() != multiplayer.get_unique_id():
		set_process(false)
		set_physics_process(false)
	
	input_direction = Input.get_vector("Left", "Right", "Forward", "Backward")

func _physics_process(delta):
	input_direction = Input.get_vector("Left", "Right", "Forward", "Backward")
	if Input.is_action_just_pressed("Jump"):
		jump.rpc(multiplayer.get_unique_id())
	neckrotation.rpc()
	
	
@rpc("call_local")
func neckrotation():
	player.neckrot = %Neck.transform.basis
	#print(player.neckrot)

@rpc("call_local")
func jump(id):
	if multiplayer.is_server():
		player.do_jump = true
		#print(str(id) + "just jumped!")
