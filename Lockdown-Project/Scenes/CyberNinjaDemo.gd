extends CharacterBody2D

@onready var animPlayer : AnimationPlayer = $AnimationPlayer
var agent: NavigationAgent2D
var speed: float = 300

@export var point1 : Node2D
@export var point2 : Node2D
@export var point3 : Node2D
@export var point4 : Node2D
@export var point5 : Node2D

var goingTo : int = 1

func _ready():
	agent = get_node("NavigationAgent2D")
	agent.target_position = point1.global_position

func _physics_process(delta):
	if (agent.is_navigation_finished()):
		if goingTo == 1:
			agent.target_position = point2.global_position
			goingTo = 2
		elif goingTo == 2:
			agent.target_position = point3.global_position
			goingTo = 3
		elif goingTo == 3:
			agent.target_position = point4.global_position
			goingTo = 4
		elif goingTo == 4:
			agent.target_position = point5.global_position
			goingTo = 5
		else:
			agent.target_position = point1.global_position
			goingTo = 1

	var diff: Vector2 = agent.get_next_path_position() - global_position
	var dir: Vector2 = diff.normalized()
	velocity = dir * speed

	# Animation Section
	if (velocity.y > 70 && velocity.y > velocity.x):
		animPlayer.play("CNA_Walk_Down")
		
	elif (velocity.y < -70 && velocity.y < velocity.x):
		animPlayer.play("CNA_Walk_Up")
	
	elif (velocity.x > 0):
		animPlayer.play("CNA_Walk_Right")
	
	else:
		animPlayer.play("CNA_Walk_Left")

	move_and_slide()
	
