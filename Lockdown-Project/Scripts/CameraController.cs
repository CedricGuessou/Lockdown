using Godot;
using System;
using System.Security.Cryptography;

public partial class CameraController : Node2D
{
	private Camera2D _cam;
	[Export] Label label;

	private const float zoomInScale = 1.1f; // Amount the camera scales in with a single "click" of a mouse scroll
	private const float zoomOutScale = .9f; // Amount the camera scales out with a single "click" of a mouse scroll
	private const float slerpSpeed = 200f; // Speed the camera smoothly moves at
	private const float panSpeed = 1500f; // Speed the camera pans at

	// Variables needed for click and drag method
	Vector2 dragStartMousePos = Vector2.Zero; // Where the mouse was at the start of the drag
	Vector2 dragStartCameraPos = Vector2.Zero; // Where the camera was at the start of the drag
	bool dragging = false; // Bool to track state of dragging

	// Called when the node enters the scene tree for the first time.
	public override void _Ready()
	{
		_cam = GetNode<Camera2D>("MainCamera");
	}

	// Called every frame. 'delta' is the elapsed time since the previous frame.
	public override void _Process(double delta)
	{
		Zoom(delta);
		SimplePan(delta);
		ClickAndDrag();
		SlowMo();
	}

	/// <summary>
	/// Zooms the camera when called
	/// </summary>
	private void Zoom(double delta)
	{
		Vector2 zoomVec = _cam.Zoom;
		// Zoom in event is called
		if(Input.IsActionJustPressed("camera_zoom_in"))
		{
			zoomVec.X *= zoomInScale;
			zoomVec.Y *= zoomInScale;
			label.Scale = Vector2.One / _cam.Zoom;
		}

		// Zoom out
		if (Input.IsActionJustPressed("camera_zoom_out"))
		{
			zoomVec.X *= zoomOutScale;
			zoomVec.Y *= zoomOutScale;
			label.Scale = Vector2.One / _cam.Zoom;
		}

		_cam.Zoom =_cam.Zoom.Slerp(zoomVec, slerpSpeed * (float)delta); // Slerps zoom (just a smoothing thing, delta is there for consistency)
	}

	/// <summary>
	/// Pans the camera using WASD
	/// </summary>
	/// <param name="delta">Time passed since last frame</param>
	void SimplePan(double delta)
	{
		Vector2 moveAmount = Vector2.Zero;
		if(Input.IsActionPressed("camera_move_right"))
		{
			moveAmount.X += 1;
		}
		if(Input.IsActionPressed("camera_move_left"))
		{
			moveAmount.X -= 1;
		}
		if(Input.IsActionPressed("camera_move_up"))
		{
			moveAmount.Y -= 1;
		}
		if(Input.IsActionPressed("camera_move_down"))
		{
			moveAmount.Y += 1;
		}

		moveAmount = moveAmount.Normalized();
		_cam.Position += moveAmount * (float)delta * panSpeed * (1/_cam.Zoom.X);
	}

	/// <summary>
	/// Pans the camera on a mouse click as opposed to WASD
	/// </summary>
	void ClickAndDrag()
	{
		if(!dragging && Input.IsActionJustPressed("camera_pan"))
		{
			// Records positions at the start of drag
			// and switches to dragging state when the middle
			// mouse is clicked down
			dragStartMousePos = GetViewport().GetMousePosition();
			dragStartCameraPos = _cam.Position;

			dragging = true;
		}

		if(dragging && Input.IsActionJustReleased("camera_pan"))
		{
			// Middle mouse is released, no more dragging
			dragging = false;
		}

		if(dragging)
		{
			// Math to drag the mouse
			Vector2 curMousePosition = GetViewport().GetMousePosition();
			Vector2 moveVector = curMousePosition - dragStartMousePos;

			_cam.Position = dragStartCameraPos - moveVector * 1/_cam.Zoom.X;
		}
	}

	void SlowMo()
	{
		if (Input.IsActionJustReleased("SlowMo") && Engine.TimeScale == 1)
		{
			Engine.TimeScale = 0.3;
			GD.Print("slow");
			
		}
		else if(Input.IsActionJustReleased("SlowMo"))
		{
			Engine.TimeScale = 1;
			GD.Print("Normal");
		}

	}


}
