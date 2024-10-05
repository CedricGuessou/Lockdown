extends Sprite2D

@export var guard: CharacterBody2D;

signal clicked

func _Input(event):
	if (event is InputEventMouseButton && !event.pressed && event.button_index == MOUSE_BUTTON_RIGHT && !guard.GuardGD.selected):
		if get_rect().has_point(event.position):
			clicked.emit()
