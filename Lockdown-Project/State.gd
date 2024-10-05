class_name State extends Node2D

## Called by the state machine on the engine's main loop tick.
func update(_delta: float) -> void:
	pass

## Called by the state machine on the engine's physics update tick.
func physics_update(_delta: float) -> void:
	pass

## Called by the state machine upon changing the active state. The `data` parameter
## is a dictionary with arbitrary data the state can use to initialize itself.
func enter() -> void:
	pass

## Called by the state machine before changing the active state. Use this function
## to clean up the state.
func exit() -> void:
	pass

## Emitted when the state finishes and wants to transition to another state.
signal transition(currentState: String, next_state_path: String)

## Called by the state machine when receiving unhandled input events.
##func handle_input(_event: InputEvent) -> void:
##	pass
