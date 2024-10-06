using Godot;
using System;

public partial class AlertButton : Button
{
	private CharacterBody2D guard;
	private Camera2D camera;
	private Vector2 g_pos;
	
	private bool scrollBack = false;
	private float scrollSpeed = 10f;
	
	// Called when the node enters the scene tree for the first time.
	public override void _Ready()
	{
		guard = GetNode<CharacterBody2D>("../GuardJdw");
		camera = GetNode<Camera2D>("../MainCamera");
	}

	// Called every frame. 'delta' is the elapsed time since the previous frame.
	public override void _Process(double delta)
	{
		Vector2 zoom;
		zoom = camera.Zoom;
		Scale = new Vector2(1 / zoom.X, 1 / zoom.Y);
		Vector2 screenSize = GetViewportRect().Size;
		Rect2 camBounds = new Rect2(camera.GlobalPosition - screenSize / 2, screenSize);
		g_pos = guard.Position;
		
		if(!camBounds.HasPoint(guard.GlobalPosition))
		{
			Vector2 alert_pos = g_pos;
			alert_pos.X = Mathf.Clamp(alert_pos.X, camBounds.Position.X, camBounds.Position.X + camBounds.Size.X - 140);
			alert_pos.Y = Mathf.Clamp(alert_pos.Y, camBounds.Position.Y, camBounds.Position.Y + camBounds.Size.Y - 140);
			this.Position = alert_pos;
		}
		else
		{
			g_pos.X -= 70;
			g_pos.Y -= 220;
			this.Position = g_pos;
		}	
		
		if(scrollBack)
		{
			camera.GlobalPosition = camera.GlobalPosition.Lerp(g_pos, scrollSpeed * (float)delta);
			
			if (camera.GlobalPosition.DistanceTo(g_pos) < 1f)
			{
				scrollBack = false;
			}
		}
	}
	
	private void _on_pressed()
	{
		scrollBack = true;
	}
}
