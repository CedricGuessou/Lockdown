using Godot;
using System;

public partial class Guard : Node2D
{
	[Export] public int stamina;
	
	// Called when the node enters the scene tree for the first time.
	public override void _Ready()
	{
	}

	// Called every frame. 'delta' is the elapsed time since the previous frame.
	public override void _Process(double delta)
	{
		// GlobalPosition += new Vector2(10, 10) * (float)delta;

		if (Input.IsKeyPressed(Key.W))
		{
			GetNode<AnimationPlayer>("Animation Play").Play("WalkDown");
			GlobalPosition += new Vector2(0, -50) * (float)delta;
		}

		if (Input.IsKeyPressed(Key.S))
		{
		}
	}
}
