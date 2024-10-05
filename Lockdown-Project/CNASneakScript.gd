extends State
class_name CNASneak

signal transition(currentState: String, next_state_path: String)

func enter() -> void:
	#find a path to the objective (which avoids cameras and soldiers?)
	#connect to a signal to tell you if you've been spotted
	
func update(delta: float) -> void:
	#if you recieve the signal to tell you you've been spotted:
		#if stamina > 25:
			transition.emit(self, "fight")
		#else:
			transition.emit(self, "run")
	#if you see an active camera:
		#if you have more than 70 stamina:
			#hack the camera
	#if you see a camera or a guard vision cone:
		#pick a new path to avoid the vision area

func physics_update(delta: float) -> void:
	#move down the path you picked in the enter function
	
func exit() -> void:
	pass

