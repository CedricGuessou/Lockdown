using Godot;
using System;

public partial class Guard : CharacterBody2D
{
	[Export] public int stamina;
	public Node collision;
	private Vector2 targetPosition;
	private float speed = 30f;

	private NavigationAgent2D agent;
	
	// Called when the node enters the scene tree for the first time.
	public override void _Ready()
	{
		targetPosition = GlobalPosition;
	}

	/*
	public override void _Input(InputEvent @event)
	{
		
		if (@event is InputEventMouseButton e && !e.Pressed && e.ButtonIndex == MouseButton.Right)
		{
			Rid map = GetWorld2D().NavigationMap;
			Vector2 p = NavigationServer2D.MapGetClosestPoint(map, e.Position);
			agent.TargetPosition = e.Position;
		}
		
	}
	*/

	// Called every frame. 'delta' is the elapsed time since the previous frame.
	public override void _PhysicsProcess(double delta)
	{
		Movement(delta);

		/*
		if (agent.IsNavigationFinished())
			return;
		
		Vector2 diff = agent.GetNextPathPosition() - GlobalPosition;
		Vector2 dir = diff.Normalized();
		Velocity = dir * speed;
		MoveAndSlide();
		*/
	}

	public void Movement(double delta)
	{
		// GlobalPosition += new Vector2(10, 10) * (float)delta;

		if (Input.IsKeyPressed(Key.W))
		{
			GlobalPosition += new Vector2(0, -50) * (float)delta;
			GetNode<AnimationPlayer>("AnimationPlayer").Play("WalkUp");

		}

		if (Input.IsKeyPressed(Key.S))
		{
			GlobalPosition += new Vector2(0, 50) * (float)delta;
			GetNode<AnimationPlayer>("AnimationPlayer").Play("WalkDown");
		}

		if (Input.IsKeyPressed(Key.A))
		{
			GlobalPosition += new Vector2(-50, 0) * (float)delta;
			GetNode<AnimationPlayer>("AnimationPlayer").Play("WalkLeft");
		}

		if (Input.IsKeyPressed(Key.D))
		{
			GlobalPosition += new Vector2(50, 0) * (float)delta;
			GetNode<AnimationPlayer>("AnimationPlayer").Play("WalkRight");
		}
	}

	public void Tracking()
	{
		
	}

	public void OnCollision(Node body)
	{
		collision = body;
	}
}
