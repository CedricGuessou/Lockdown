extends Area2D

func _on_body_entered(body):
	
	queue_free()
	if body.is_in_group("Ninja"):
		body.queue_free()
	return body
