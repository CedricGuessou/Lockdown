extends Area2D

var speed = 500
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	position += transform.x * speed * delta



func _on_body_entered(body):
	
	queue_free()
	if body.is_in_group("Ninja"):
		body.queue_free()
	return body
