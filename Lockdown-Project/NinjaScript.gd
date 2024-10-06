extends CharacterBody2D

@export var stamina = 100

var walkSpeed = 100
var runSpeed = 200

var ninjaActions = ["WALK", "RUN", "ATTACK", "VENT", "HACK"]
@export var ninjaCurrentAction : String

var animationPlayer : AnimationPlayer
var navigationAgent : NavigationAgent2D
var ninjaSprite : Sprite2D

#IDK why this works but Josh does
var stateMachine = StateMachine.new()

signal goalReached()

signal ninjaSpotted()

var direction = Vector3()

func _ready():
	set_physics_process(false)
	await get_tree().physics_frame
	set_physics_process(true)
	navigationAgent = $NavigationAgent2D
	stateMachine = get_node("State Machine")
	animationPlayer = get_node("AnimationPlayer")
	ninjaSprite = get_node("Sprite2D")
	#somehow detect it every time the goal changes?
	navigationAgent.target_position = get_node("State Machine").currentState.goalCoords
	direction = navigationAgent.get_next_path_position() - global_position
	direction = direction.normalized()

var timeSpentRunning = 0

#this should let it update the direction every 0.25 seconds. Let's see how that goes
var directionUpdateTimer = 0

func _physics_process(delta):
	#
	if ninjaCurrentAction == "ATTACK":
		#play the kill animation
		#Delete the targeted guard
		stateMachine.currentState.target.queue_free()
		#wait for the animation to finish
		await get_tree().create_timer(1.4).timeout
		goalReached.emit()
		return
	if timeSpentRunning >= 1:
		timeSpentRunning = 0
		stamina = stamina - 1
	directionUpdateTimer = directionUpdateTimer + delta
	navigationAgent.target_position = stateMachine.currentState.goalCoords
	#gets the next path position every frame so he doesn't switch pathing
	navigationAgent.get_next_path_position()
	if directionUpdateTimer > 0.2 && !navigationAgent.is_navigation_finished():
	#if !navigationAgent.is_navigation_finished():
		directionUpdateTimer = 0
		direction = navigationAgent.get_next_path_position() - global_position
		direction = direction.normalized()
	if ninjaCurrentAction == "WALK":
		navigationAgent.path_desired_distance = 20
		#do the walking animation in the direction you're walking
		#if he's moving more up than sideways
		#if direction[0] > direction[1]:
		#this shit doesn't work rn but I'm moving on for now...
		if direction[0] > 0:
			ninjaSprite.scale.x = abs(ninjaSprite.scale.x)
			animationPlayer.play("CNA_Walk_Side")
		else:
			ninjaSprite.scale.x = -(ninjaSprite.scale.x)
			animationPlayer.play("CNA_Walk_Side")
		velocity = direction * walkSpeed
		move_and_slide()
	if ninjaCurrentAction == "RUN":
		navigationAgent.path_desired_distance = 100
		if stamina > 0:
			if timeSpentRunning < 1:
				timeSpentRunning = timeSpentRunning + delta
			#do the running animation in the direction you're running
			velocity = direction * runSpeed
			move_and_slide()
	
# Called when the node enters the scene tree for the first time.

#some quick bs to test the attack thing
var timer = 0
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	timer += 1
	if timer == 180:
		print("NINJA!!!")
		emit_signal("ninjaSpotted")
		print("current state is now " + str(stateMachine.currentState))
	ninjaCurrentAction = stateMachine.currentState.desiredAction
	if navigationAgent.is_navigation_finished():
		emit_signal("goalReached")

#if the ninja steps on a trap, the trap causes the ninja to run this function
func got_trapped() -> void:
	if stamina > 20:
		stamina = stamina - 20
	#else:
		#die??
		
#func got_shot() -> void:
#stamina check, die if the stamina check fails
#if he deflects, lose stamina
