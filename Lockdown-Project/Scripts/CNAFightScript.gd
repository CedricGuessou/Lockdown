extends State
class_name CNAFight

var guardsList = []
#this is kinda cheating but it should be ok
@export var target : Node

var distance : Vector2

func enter() -> void:
	ninjaBody.goalReached.connect(goal_reached)
	#On entry, there should always be at least one guard in ninja's sight because he only enters attack mode once he's been spotted
	distance = abs(ninjaBody.global_position - ninjaBody.guardsInSight[0].global_position)
	target = guardsList[0]
	for guard in guardsList:
		if abs(ninjaBody.global_position - guard.global_position) < distance:
			distance = abs(ninjaBody.global_position - guard.global_position)
			target = guard
	goalCoords = target.global_position
	
	desiredAction = "RUN"
	
func goal_reached() -> void:
	#kill the target guard
	desiredAction = "ATTACK"
	print("this is where I'd KILL")
	#If there are no more guards in sight, go back into sneak mode
	if ninjaBody.guardsInSight.size() <= 0:
		transition.emit(self, "sneak")
	##If this is still the active state (meaning there are still guards around)
	if self == ninjaBody.currentState:
		#find a new guard to go after
		distance = abs(ninjaBody.global_position - ninjaBody.guardsInSight[0].global_position)
		target = guardsList[0]
		for guard in guardsList:
			if abs(ninjaBody.global_position - guard.global_position) < distance:
				distance = abs(ninjaBody.global_position - guard.global_position)
				target = guard
		goalCoords = target.global_position
