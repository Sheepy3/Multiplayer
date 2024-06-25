extends CharacterBody3D

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity:float = ProjectSettings.get_setting("physics/3d/default_gravity")

func _enter_tree() -> void:
	set_multiplayer_authority(1)

func _physics_process(delta:float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity.y -= gravity * delta

	move_and_slide()
