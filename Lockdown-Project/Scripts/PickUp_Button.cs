using Godot;
using System;

public partial class PickUp_Button : Button
{
	Guard guard = new Guard();
	// Called when the node enters the scene tree for the first time.
	public override void _Ready()
	{
		guard = GetNode<Guard>("../../../");
	}

	// Called every frame. 'delta' is the elapsed time since the previous frame.
	public override void _Process(double delta)
	{
		if((guard.collision is Item) == false)
		{
			Disabled = true;
		}
		else
		{
			if (ButtonPressed)
			{
				guard.item = (Item)guard.collision;
			}
		}
	}
}
