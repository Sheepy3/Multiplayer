extends CharacterBody3D
@onready var neck := %Neck
@onready var camera := $Neck/Camera3D
@onready var interact_ray = $Neck/Camera3D/InteractRay
@onready var player = $"."
const SPEED = 5.0
const JUMP_VELOCITY = 4.5
var direction
var do_jump:bool 
var setlabel
@export var player_id := 1:
	set(id):
		player_id = id
		%InputSynchronizer.set_multiplayer_authority(player_id)
		$Label3D.set_multiplayer_authority(player_id)

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")

func _process(delta):
	if %InputSynchronizer.get_multiplayer_authority() == multiplayer.get_unique_id():
		%Label.set_text(str(%InputSynchronizer.get_multiplayer_authority()))
		%Label.show()
		$Neck/Camera3D.make_current()
	else:
		%Panel.hide()	

func _unhandled_input(event):
	if event is InputEventMouseButton:
		Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	elif event.is_action_pressed("ui_cancel"):
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	if Input.get_mouse_mode() == Input.MOUSE_MODE_CAPTURED:
		if event is InputEventMouseMotion:
			neck.rotate_y(-event.relative.x * 0.01)
			camera.rotate_x(-event.relative.y * 0.01)
			camera.rotation.x = clamp(camera.rotation.x, deg_to_rad(-90), deg_to_rad(90))

func _physics_process(delta):
	if multiplayer.is_server():
		_apply_movement_from_input(delta)
		
func _apply_movement_from_input(delta):
	#print(player_id)
		# Add the gravity.
	if not is_on_floor():
		velocity.y -= gravity * delta

	# Handle Jump.
	if do_jump and is_on_floor():
		velocity.y = JUMP_VELOCITY	
		do_jump = false
	var input_dir = %InputSynchronizer.input_direction #Input.get_vector("Left", "Right", "Forward", "Backward")
	var neckrot = %InputSynchronizer.neckrotation
	direction = (neckrot * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	if is_on_floor():
		if direction:
			velocity.x = direction.x * SPEED
			velocity.z = direction.z * SPEED
		else:
			velocity.x = move_toward(velocity.x, 0, SPEED)
			velocity.z = move_toward(velocity.z, 0, SPEED)

	move_and_slide()	
