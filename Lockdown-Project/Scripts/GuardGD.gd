extends CharacterBody2D

@export var staminari: int = 1
@export var stamina: int
@export var highlight: PointLight2D 
# var item: Item
var collision: Node
var targetPosition: Vector2 
var speed: float = 300
var selected: bool = false

var agent: NavigationAgent2D 

var animPlayer: AnimationPlayer 

var guardState: GuardState = GuardState.MOVE

enum GuardState
{
	IDLE,
	MOVE,
	PICKUP,
	OPERATE,
	ATTACK,
}

# Called when the node enters the scene tree for the first time.
func _ready():
	animPlayer = get_node("AnimationPlayer")
	agent = get_node("NavigationAgent2D")
	targetPosition = global_position


func _input(event):
	if (event is InputEventMouseButton && !event.pressed && event.button_index == MOUSE_BUTTON_RIGHT && guardState == GuardState.MOVE):
		var map: RID = get_world_2d().get_navigation_map()
		var p = NavigationServer2D.map_get_closest_point(map, event.position)
		agent.target_position = get_global_mouse_position()

func selectedF(selectedQ):
	selected = selectedQ
	highlight.visible = selectedQ

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	if (guardState == GuardState.MOVE):
		if (agent.is_navigation_finished()):
			return

		var diff: Vector2 = agent.get_next_path_position() - global_position
		var dir: Vector2 = diff.normalized()
		velocity = dir * speed

		# Animation Section
		if (velocity.y > 70 && velocity.y > velocity.x):
			animPlayer.play("GuardPokemon/WalkDown")
			
		elif (velocity.y < -70 && velocity.y < velocity.x):
			animPlayer.play("GuardPokemon/WalkUp")
		
		elif (velocity.x > 0):
			animPlayer.play("GuardPokemon/WalkRight")
		
		else:
			animPlayer.play("GuardPokemon/WalkLeft")

		move_and_slide()
