extends CharacterBody2D

@onready var CNA: CharacterBody2D = get_tree().get_first_node_in_group("Ninja")

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
var highlightPlayer: AnimationPlayer 

@export var rayCastTL : RayCast2D
@export var rayCastTR : RayCast2D
@export var rayCastBL : RayCast2D
@export var rayCastBR : RayCast2D
@export var line2d : Line2D

var guardState: GuardState = GuardState.IDLE

signal ninjaSpotted

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
	highlightPlayer = get_node("HighlightPlayer")
	agent = get_node("NavigationAgent2D")
	targetPosition = global_position
	var guards = get_tree().get_nodes_in_group("Guards")
	for guard in guards:
		rayCastTL.add_exception(guard)
		rayCastTR.add_exception(guard)
		rayCastBL.add_exception(guard)
		rayCastBR.add_exception(guard)

func _input(event):
	if (event is InputEventMouseButton && !event.pressed && event.button_index == MOUSE_BUTTON_RIGHT):
		selected = false
		highlight.visible = false
	
	if (event is InputEventMouseButton && !event.pressed && event.button_index == MOUSE_BUTTON_LEFT && guardState == GuardState.MOVE && selected):
		var map: RID = get_world_2d().get_navigation_map()
		var p = NavigationServer2D.map_get_closest_point(map, event.position)
		agent.target_position = get_global_mouse_position()

func selectedF():
	var guards = get_tree().get_nodes_in_group("Guards")
	for guard in guards:
		if guard.selected:
			guard.selected = false
			guard.highlight.visible = false
	selected = true
	highlight.visible = true
	highlightPlayer.play("GuardPokemon/SelectedIdle")
	guardState = GuardState.MOVE

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	print(name + " " + str(guardState))
	if CNA:
		# Top Left Rayast
		rayCastTL.target_position = Vector2(CNA.global_position.x - global_position.x, CNA.global_position.y - global_position.y)
		print(str(CNA.global_position))
		if rayCastTL.is_colliding():
			if rayCastTL.get_collider().is_in_group("Ninja"):
				ninjaSpotted.emit()
				guardState = GuardState.ATTACK
		
		# Top Right Rayast
		rayCastTR.target_position = Vector2(CNA.global_position.x - global_position.x, CNA.global_position.y - global_position.y)
		print(str(CNA.global_position))
		if rayCastTR.is_colliding():
			if rayCastTR.get_collider().is_in_group("Ninja"):
				ninjaSpotted.emit()
				guardState = GuardState.ATTACK
		
		# Bottom Left Rayast
		rayCastBL.target_position = Vector2(CNA.global_position.x - global_position.x, CNA.global_position.y - global_position.y)
		print(str(CNA.global_position))
		if rayCastBL.is_colliding():
			if rayCastBL.get_collider().is_in_group("Ninja"):
				ninjaSpotted.emit()
				guardState = GuardState.ATTACK
		
		# Bottom Right Rayast
		rayCastBR.target_position = Vector2(CNA.global_position.x - global_position.x, CNA.global_position.y - global_position.y)
		print(str(CNA.global_position))
		if rayCastBR.is_colliding():
			if rayCastBR.get_collider().is_in_group("Ninja"):
				ninjaSpotted.emit()
				guardState = GuardState.ATTACK
	
	if (guardState == GuardState.MOVE):
		if (agent.is_navigation_finished()):
			animPlayer.play("GuardPokemon/RESET")
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
	
	if (guardState == GuardState.ATTACK):
		pass
