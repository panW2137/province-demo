extends Camera2D

#thank you chatGPT

var mouse_pressed = false
var last_mouse_pos = Vector2.ZERO

func _input(event):
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_MIDDLE:
			mouse_pressed = event.is_pressed()
			last_mouse_pos = event.position
			
		if event.is_pressed():
			if event.button_index == MOUSE_BUTTON_WHEEL_UP and zoom.x < 10:
				zoom *= 1.1
			if event.button_index == MOUSE_BUTTON_WHEEL_DOWN and zoom.x > 0.1:
				zoom /= 1.1
	elif event is InputEventMouseMotion and mouse_pressed:
		var delta = (event.position - last_mouse_pos) / zoom
		position -= delta
		last_mouse_pos = event.position
