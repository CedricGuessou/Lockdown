extends Area2D



# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	position.x -= 5 * delta


func _on_body_entered(body):
	if body.is_in_group("Ninja") or body.is_in_group("Guard"):
		body.queue_free()
		return
	
