extends CharacterBody2D

var walkSpeed = 100
var runSpeed = 200

var ninjaActions = ["WALK", "RUN", "ATTACK", "VENT", "HACK"]
@export var ninjaCurrentAction : String

#var animationPlayer : AnimationPlayer
var navigationAgent : NavigationAgent2D

func _ready():
	set_physics_process(false)
	await get_tree().physics_frame
	set_physics_process(true)
	navigationAgent = $NavigationAgent2D
	#animationPlayer = $AnimationPlayer


func _physics_process(delta):
	var direction = Vector3()
	
	if ninjaCurrentAction == "WALK":
		
	navigationAgent.target_position = get_global_mouse_position()
	
	direction = navigationAgent.get_next_path_position() - global_position
	direction = direction.normalized()
	
	velocity = direction * walkSpeed
	
	move_and_slide()
	
# Called when the node enters the scene tree for the first time.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
