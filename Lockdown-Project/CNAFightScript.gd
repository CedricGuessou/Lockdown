extends State
class_name CNAFight

var guardsList = []
#this is kinda cheating but it should be ok
@export var target : Node

var distance : Vector2

func enter() -> void:
	get_node("../../").goalReached.connect(goal_reached)
	#replace the mouse position with a function to locate the position of the nearest guard
	for guard in get_tree().get_nodes_in_group("Guards"):
		guardsList.append(guard)
	distance = abs(get_node("../../").global_position - guardsList[0].global_position)
	target = guardsList[0]
	for guard in guardsList:
		if abs(get_node("../../").global_position - guard.global_position) < distance:
			distance = abs(get_node("../../").global_position - guard.global_position)
			target = guard
	goalCoords = target.global_position
	
	desiredAction = "RUN"
	
func goal_reached() -> void:
	if self == get_node("../").currentState:
		desiredAction = "ATTACK"
		print("this is where I'd KILL")
		#refresh the guards list
		guardsList = []
		for guard in get_tree().get_nodes_in_group("Guard"):
			guardsList.append(guard)
		#find a new guard to target
		distance = abs(get_node("../../").global_position - guardsList[0].global_position)
		target = guardsList[0]
		for guard in guardsList:
			if abs(get_node("../../").global_position - guard.global_position) < distance:
				distance = abs(get_node("../../").global_position - guard.global_position)
				target = guard
		goalCoords = target.globalPosition
