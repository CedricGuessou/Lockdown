extends CharacterBody2D

@export var stamina = 100

var walkSpeed = 100
var runSpeed = 200

var ninjaActions = ["WALK", "RUN", "ATTACK", "VENT", "HACK"]
@export var ninjaCurrentAction : String

#list of guards in the ninja's vision range
var guardsInRange = []
#This creates a list of guards in the ninja's vision which its children can access
#can't statically type arrays, but these should all be CharacterBody2Ds
@export var guardsInSight = []

var animationPlayer : AnimationPlayer
var navigationAgent : NavigationAgent2D
var ninjaSprite : Sprite2D

#IDK why this works but Josh does
var stateMachine = StateMachine.new()

signal goalReached()

signal guardSpotted()

var direction = Vector3()
#var readyToNavigate : bool = false

func _ready():
	#wait for one physics frame before starting the physics process
	set_physics_process(false)
	await get_tree().physics_frame
	set_physics_process(true)
	navigationAgent = $NavigationAgent2D
	stateMachine = get_node("State Machine")
	animationPlayer = get_node("AnimationPlayer")
	ninjaSprite = get_node("Sprite2D")
	#readyToNavigate = true
	#somehow detect it every time the goal changes?
	navigationAgent.target_position = get_node("State Machine").currentState.goalCoords
	direction = navigationAgent.get_next_path_position() - global_position
	direction = direction.normalized()

var timeSpentRunning = 0

#this should let it update the direction every 0.25 seconds. Let's see how that goes
var directionUpdateTimer = 0

func _physics_process(delta):
	#check each enemy in range to make sure it's in line of sight
	var spaceState = get_world_2d().direct_space_state
	#for some fucking reason, raycast params need to be put into a weird structure :(
	var raycastParams = PhysicsRayQueryParameters2D.new()
	for guard in guardsInRange:
		#raycast from the ninja to the guard on the ninja's collision layer
		raycastParams.from = position
		raycastParams.to = guard.position
		raycastParams.exclude = [self]
		raycastParams.collision_mask = collision_mask
		var sightCheck = spaceState.intersect_ray(raycastParams)
		#if the first thing the ray hits is the targeted guard, then add that guard to the list of guards in sight, if he isn't already in there
		if sightCheck && sightCheck["collider"] == guard:
			if !(guard in guardsInSight):
				guardsInSight.append(guard)
		#if the LOS check fails and the guard was previously in sight, remove him
		elif guard in guardsInSight:
			guardsInSight.erase(guard)
			#note: normally you can't use .erase while iterating through an array, but we're erasing and iterating through different arrays, so it should be fine :)
	if ninjaCurrentAction == "ATTACK":
		#play the kill animation
		#Delete the targeted guard
		#NOTE: is the guard guraunteed to be in range?
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
	#if readyToNavigate:
	navigationAgent.get_next_path_position()
	#but only changes direction every 0.2 seconds to help keep him from dancing between pathfinding points
	if directionUpdateTimer > 0.2 && !navigationAgent.is_navigation_finished():
		directionUpdateTimer = 0
		direction = navigationAgent.get_next_path_position() - global_position
		direction = direction.normalized()
	if ninjaCurrentAction == "WALK":
		navigationAgent.path_desired_distance = 20
		#do the walking animation in the direction you're walking
		#if he's moving more up than sideways
		#if direction[0] > direction[1]:
		#TODO: fix this with code copied from ninjatest. It just doesn't work right now
		if direction[0] > 0:
			animationPlayer.play("CNA_Walk_Right")
		else:
			animationPlayer.play("CNA_Walk_Left")
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

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	#if there's a guard within your LOS
	if guardsInSight.size() > 0:
		print("NINJA!!!")
		#emit a signal to switch to the attack state and kill them
		emit_signal("guardSpotted")
		print("current state is now " + str(stateMachine.currentState))
	ninjaCurrentAction = stateMachine.currentState.desiredAction
	#TODO: get this to only emit once per pathfinding process. Otherwise I think it might mess with animations?
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

#I think the body should track vision and then pass that down to all its children
func _on_sight_area_body_entered(body):
	if body in get_tree().get_nodes_in_group("Guards"):
		guardsInRange.append(body)
		#Do a raycast to the guard
		#add it to the list if the raycast succeeds

func _on_sight_area_body_exited(body):
	if body in guardsInRange:
		guardsInRange.erase(body)
		if body in guardsInSight:
			guardsInSight.erase(body)
		
		


