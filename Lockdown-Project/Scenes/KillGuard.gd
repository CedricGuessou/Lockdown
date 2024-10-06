extends Area2D

@export var ninja: CharacterBody2D

func _body_entered(body):
	if body in get_tree().get_nodes_in_group("Guards"):
		ninja.swipe()
		await get_tree().create_timer(0.8).timeout
		body.die()
