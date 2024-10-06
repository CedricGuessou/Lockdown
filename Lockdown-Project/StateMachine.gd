class_name StateMachine extends Node2D


#Make a public variable to set the initial state. This should be set to sneak
@export var initialState : State

var states: Dictionary = {}
var currentState : State

# Called when the node enters the scene tree for the first time.
func _ready():
	# Tell the machine what all the states are
	# and tap in to all their transition signals
	for child in get_children():
		if child is State:
			states[child.name.to_lower()] = child
			child.transition.connect(switch_state)
			
	#Enter the initial state you're supposed to be in
	if initialState:
		initialState.enter()
		currentState = initialState

## Update the State on the proscess tick	
func _process(delta):
	if currentState:
		currentState.update(delta)	

##Update the state on the physics tick
func _physics_process(delta):
	if currentState:
		currentState.physics_update
	
# Switch the current state
func switch_state(state, newStateName):
	#check the state trying to transition is the current state for saftey
	if state != currentState:
		return
	var newState = states.get(newStateName.to_lower())
	#another saftey check to make sure the state exists
	if !newState:
		return
	if currentState:
		currentState.exit()
	
	newState.enter()

## The current state of the state machine.
##@onready var state: State = (func get_initial_state() -> State:
##	return initial_state if initial_state != null else get_child(0)
##).call()
# State machines usually access data from the root node of the scene they're part of: the owner.
# We wait for the owner to be ready to guarantee all the data and nodes the states may need are available.
##await owner.ready
##state.enter("")
