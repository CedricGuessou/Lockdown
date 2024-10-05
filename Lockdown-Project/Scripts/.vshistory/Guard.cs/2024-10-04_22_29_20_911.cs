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
		Movement(delta);
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
}
