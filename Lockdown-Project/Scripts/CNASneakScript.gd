extends State
class_name CNASneak

func enter() -> void:
	get_node("../../").goalReached.connect(goal_reached)
	#replace the mouse position with a function to locate the goal node's global position
	goalCoords = get_global_mouse_position()
	desiredAction = "WALK"
	#connect to a signal to tell you if you've been spotted
	#this should come from a guard, but for now it comes from the ninja's body
	get_node("../../").ninjaSpotted.connect(ninja_spotted)

func goal_reached() -> void:
	if self == get_node("../").currentState:
		#replace this with a function to start hacking the door
		print("this is where I'd start hacking the door")
		desiredAction = "HACK"

#func update(delta: float) -> void:
	#if you recieve the signal to tell you you've been spotted:
		#if stamina > 25:
			#transition.emit(self, "fight")
		#else:
			#transition.emit(self, "run")
	#if you see an active camera:
		#if you have more than 70 stamina:
			#hack the camera
	#if you see a camera or a guard vision cone:
		#pick a new path to avoid the vision area
		
func ninja_spotted() -> void:
	transition.emit(self, "fight")

func physics_update(delta: float) -> void:
	pass
	#NinjaScript is handling movement, the states are just setting targets
	
#func exit() -> void:
	pass

