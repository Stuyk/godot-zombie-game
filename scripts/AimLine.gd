extends Line2D

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var marker: Marker2D = get_parent();
	if (marker):
		self.clear_points();
		self.add_point(get_global_mouse_position());
