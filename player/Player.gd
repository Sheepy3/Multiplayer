extends CharacterBody3D
@onready var neck := $Neck
@onready var camera := $Neck/Camera3D
@onready var interact_ray = $Neck/Camera3D/InteractRay
@onready var player = $"."
const SPEED = 5.0
const JUMP_VELOCITY = 4.5
var direction
@export var player_id := 1:
	set(id):
		player_id = id
		%InputSynchronizer.set_multiplayer_authority(player_id)
	
func _on_ready():
	#%InputSynchronizer.set_multiplayer_authority(player_id)
	pass
# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")

func _ready():
	#self.ready.connect(_on_ready)
	pass



func _physics_process(delta):
	if multiplayer.is_server():
		_apply_movement_from_input(delta)
		
func _apply_movement_from_input(delta):
	#print(player_id)
		# Add the gravity.
	if not is_on_floor():
		velocity.y -= gravity * delta

	# Handle Jump.
	if Input.is_action_just_pressed("Jump") and is_on_floor():
		velocity.y = JUMP_VELOCITY	
	var input_dir = %InputSynchronizer.input_direction #Input.get_vector("Left", "Right", "Forward", "Backward")
	direction = (neck.transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	if direction:
		velocity.x = direction.x * SPEED
		velocity.z = direction.z * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		velocity.z = move_toward(velocity.z, 0, SPEED)

	move_and_slide()	
