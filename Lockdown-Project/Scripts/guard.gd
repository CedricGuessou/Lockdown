extends CharacterBody2D

@export var bulletNode : Node2D
@export var marker2D : Marker2D

var _bullet = preload("res://Scenes/bullet.tscn")

const SPEED = 300.0
const JUMP_VELOCITY = -400.0

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")


func _physics_process(_delta):
	# Add the gravity.
	#if not is_on_floor():
	#	velocity.y += gravity * delta

	# Handle jump.
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction1 = Input.get_axis("camera_move_left", "camera_move_right")
	
	if direction1:
		velocity.x = direction1 * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		
	var direction2 = Input.get_axis("camera_move_up", "camera_move_down")
	
	if direction2:
		velocity.y = direction2 * SPEED
	else:
		velocity.y = move_toward(velocity.y, 0, SPEED)

	shoot()
	move_and_slide()

func shoot():
	if Input.is_action_just_pressed("shoot_test"):
		var bullet = _bullet.instantiate()
		bulletNode.add_child(bullet)
		bullet.look_at(get_global_mouse_position())
		
		
		
		bullet.global_position = marker2D.global_position
