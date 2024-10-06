extends Node2D

@onready var ninja = get_tree().get_first_node_in_group("Ninja")

var speed = 500
var move_vec : Vector2

# Called when the node enters the scene tree for the first time.
func _ready():
	var dir = global_position.direction_to(ninja.global_positon)
	rotation = dir.angle()
	move_vec = Vector2(speed, 0).rotated(dir)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	position += move_vec * delta


