extends Sprite2D

# NOTE This script is not being utilized and was replaced by a button

@export var guard: CharacterBody2D;

signal clicked

func _input(event):
	if (event is InputEventMouseButton && !event.pressed && event.button_index == MOUSE_BUTTON_LEFT && !guard.selected):
		print("A");
		if get_rect().has_point(to_local(event.global_position)):
			print("B");
			clicked.emit()
