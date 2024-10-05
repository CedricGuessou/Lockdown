extends Area2D


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if Input.is_action_pressed("camera_move_right"):
		move_local_x(1)



func _on_body_entered(body):
	
	queue_free()
	if body.is_in_group("Ninja"):
		body.queue_free()
	return body
