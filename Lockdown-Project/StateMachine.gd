class_name StateMachine extends Node2D

## The initial state of the state machine. If not set, the first child node is used.
@export var initial_state: State = null

## The current state of the state machine.
@onready var state: State = (func get_initial_state() -> State:
	return initial_state if initial_state != null else get_child(0)
).call()

# Called when the node enters the scene tree for the first time.
func _ready():
	# Give every state a reference to the state machine.
	for state_node: State in find_children("*", "State"):
		state_node.finished.connect(_transition_to_next_state)
	
	# State machines usually access data from the root node of the scene they're part of: the owner.
	# We wait for the owner to be ready to guarantee all the data and nodes the states may need are available.
	await owner.ready
	state.enter("")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


##get the rest of the state machine from
##https://www.gdquest.com/tutorial/godot/design-patterns/finite-state-machine/
