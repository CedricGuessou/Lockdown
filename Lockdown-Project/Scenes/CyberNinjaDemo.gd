extends CharacterBody2D

@onready var animPlayer : AnimationPlayer = $AnimationPlayer

func _ready():
	animPlayer.play("CNA_Attack")
