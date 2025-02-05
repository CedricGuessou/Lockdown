using Godot;
using System;

public partial class AlertButton : Button
{
	private CharacterBody2D guard;
	private Camera2D camera;
	private Vector2 g_pos;
	
	private bool scrollBack = false;
	private float scrollSpeed = 10f;
	
	private bool slow = false;
	
	// Called when the node enters the scene tree for the first time.
	public override void _Ready()
	{
		guard = GetNode<CharacterBody2D>("../GuardJdw");
		camera = GetNode<Camera2D>("../MainCamera");
	}

	// Called every frame. 'delta' is the elapsed time since the previous frame.
	public override void _Process(double delta)
	{
		if (Input.IsActionJustPressed("slow_mo_test"))
		{
			Engine.TimeScale = 0.5;
		}
		else if(Input.IsActionJustReleased("slow_mo_test"))
		{
			Engine.TimeScale = 1;
		}
		
		Vector2 zoom;
		zoom = camera.Zoom;
		Scale = new Vector2(1 / zoom.X, 1 / zoom.Y);
		Vector2 screenSize = GetViewportRect().Size * Scale;
		Rect2 camBounds = new Rect2(camera.GlobalPosition - screenSize / 2, screenSize);
		g_pos = guard.Position;
		
		if(!camBounds.HasPoint(guard.GlobalPosition))
		{
			Vector2 alert_pos = g_pos;
			alert_pos.X = Mathf.Clamp(alert_pos.X, camBounds.Position.X + 70, camBounds.Position.X + camBounds.Size.X - 210);
			alert_pos.Y = Mathf.Clamp(alert_pos.Y, camBounds.Position.Y + 70, camBounds.Position.Y + camBounds.Size.Y - 210);
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
