extends Node2D

var _bullet = preload("res://Scenes/bullet.tscn")
@export var bulletNode : Node2D
@export var marker_2d : Marker2D
@export var guard : CharacterBody2D

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if Input.is_action_just_pressed("shoot_test"):
		var bullet = _bullet.instantiate()
		bulletNode.add_child(bullet)
		bullet.look_at(get_global_mouse_position())
		bullet.global_position = Vector2(500, 500)
		
		
		
	
