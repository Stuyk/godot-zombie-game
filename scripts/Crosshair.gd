extends Sprite2D

func _process(delta):
	var mousePos = get_global_mouse_position();
	position = Vector2(mousePos.x - 4, mousePos.y - 4)
