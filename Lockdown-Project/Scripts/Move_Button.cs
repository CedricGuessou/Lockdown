using Godot;
using System;

public partial class Move_Button : Button
{
	[Export] public Guard guard;
	public NavigationAgent2D nav;

	// Called when the node enters the scene tree for the first time.
	public override void _Ready()
	{
		nav = GetNode<NavigationAgent2D>("NavigationAgent2D");
	}

	// Called every frame. 'delta' is the elapsed time since the previous frame.
	public override void _Process(double delta)
	{
		if (Input.IsMouseButtonPressed(MouseButton.Left))
		{
			nav.TargetPosition = GetGlobalMousePosition();
		}

	}
}
