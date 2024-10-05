extends State
class_name CNASneak


func enter() -> void:
	#find a path to the objective (which avoids cameras and soldiers?)
	navigationAgent.target_position = get_global_mouse_position()
	cyberNinja.ninjaCurrentAction = "WALK"
	#connect to a signal to tell you if you've been spotted
	
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

func physics_update(delta: float) -> void:
	pass
	#NinjaScript is handling movement, the states are just setting targets
	
#func exit() -> void:
	pass

