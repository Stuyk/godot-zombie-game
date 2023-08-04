extends CharacterBody2D

var speed = 40
var isDead = false;
var isReady = false;

var startPos: Vector2;
var target: Vector2;
var direction: Vector2;

func process_collision(collision: KinematicCollision2D):
	isDead = true;
	$Impact.play();
	
	var hitObject = collision.get_collider();
	if (!hitObject.has_method("hit")):
		return;
		
	hitObject.hit();
	
func setup(pos: Vector2, cursor: Vector2):
	self.global_position = pos;
	direction = (cursor - pos).normalized();
	startPos = pos;
	target = cursor;
	isReady = true;

func _physics_process(delta):
	if (!isReady):
		return;
	
	if (velocity == Vector2.ZERO):
		velocity = Vector2(speed, 0).rotated(rotation)
	
	if ($PointLight2D.energy > 0):
		$PointLight2D.energy = lerpf($PointLight2D.energy, 0, 0.05);
		
	if ($Sprite2D.modulate.a > 0):
		$Sprite2D.modulate.a = lerpf($Sprite2D.modulate.a, 0, 0.05);
		
	if (isDead && !$Impact.is_playing()):
		queue_free();

	self.look_at(target);
	var collide: KinematicCollision2D = move_and_collide(direction * speed);
	if (collide && !isDead):
		process_collision(collide);

