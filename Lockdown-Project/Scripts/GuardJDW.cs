using Godot;
using System;

public partial class GuardJDW : CharacterBody2D
{
	[Export] public int stamina;
	public Item item;
	[Export] public PointLight2D highlight;
	public Node collision;
	private Vector2 targetPosition;
	private float speed = 300f;

	private NavigationAgent2D agent;

	private AnimationPlayer animPlayer;

	GuardState guardState = GuardState.MOVE;

	private enum GuardState
	{
		IDLE,
		MOVE,
		PICKUP,
		OPERATE,
		ATTACK,
	}

	// Called when the node enters the scene tree for the first time.
	public override void _Ready()
	{
		animPlayer = GetNode<AnimationPlayer>("AnimationPlayer");
		agent = GetNode<NavigationAgent2D>("NavigationAgent2D");
		targetPosition = GlobalPosition;
	}

	public override void _Input(InputEvent @event)
	{
		if (@event is InputEventMouseButton e && !e.Pressed && e.ButtonIndex == MouseButton.Right && guardState == GuardState.MOVE)
		{
			Rid map = GetWorld2D().NavigationMap;
			Vector2 p = NavigationServer2D.MapGetClosestPoint(map, e.Position);
			agent.TargetPosition = GetGlobalMousePosition();
		}
	}

	// Called every frame. 'delta' is the elapsed time since the previous frame.
	public override void _PhysicsProcess(double delta)
	{
		if (guardState == GuardState.MOVE)
		{
			if (agent.IsNavigationFinished())
				return;

			Vector2 diff = agent.GetNextPathPosition() - GlobalPosition;
			Vector2 dir = diff.Normalized();
			Velocity = dir * speed;

			// Animation Section
			if (Velocity.Y > 70 && Velocity.Y > Velocity.X)
			{
				animPlayer.Play("GuardPokemon/WalkDown");
			}
			else if (Velocity.Y < -70 && Velocity.Y < Velocity.X)
			{
				animPlayer.Play("GuardPokemon/WalkUp");
			}
			else if (Velocity.X > 0)
			{
				animPlayer.Play("GuardPokemon/WalkRight");
			}
			else
			{
				animPlayer.Play("GuardPokemon/WalkLeft");
			}

			MoveAndSlide();
		}
	}
}
