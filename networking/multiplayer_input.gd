extends MultiplayerSynchronizer

@onready var player = $".."

var input_direction :Vector2
var player_id
@export var neckrotation:Basis
# Called when the node enters the scene tree for the first time.
func _ready():
	if get_multiplayer_authority() != multiplayer.get_unique_id():
		set_process(false)
		set_physics_process(false)
	player_id = multiplayer.get_unique_id()


func _physics_process(delta):
	input_direction = Input.get_vector("Left", "Right", "Forward", "Backward")
	neckrotation = %Neck.transform.basis
	if Input.is_action_just_pressed("Jump"):
		jump.rpc()

@rpc("call_local")
func jump():
	if multiplayer.is_server():
		player.do_jump = true
