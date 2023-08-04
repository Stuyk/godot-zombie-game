extends CharacterBody2D

@export var health_kit: PackedScene;
@onready var player_state: PlayerState = get_node("/root/PlayerState");
@export var movement_speed: float = 2.2;

var next_update: float = Time.get_ticks_msec();
var next_light_off_time: float = Time.get_ticks_msec();
var hit_cooldown = Time.get_ticks_msec();
var next_growl_cooldown = Time.get_ticks_msec();
var rng = RandomNumberGenerator.new()

var health = 10;
var ranOnce = false;

func _ready():
	if (ranOnce):
		queue_free();
		return;
	
	ranOnce = true;
	$NavigationAgent2D.path_desired_distance = 4.0;
	$NavigationAgent2D.target_desired_distance = 4.0;
	call_deferred("setup");

func setup(pos: Vector2):
	self.global_position = pos;
	set_movement_target(player_state.pos);
	
func set_movement_target(targetPoint: Vector2):
	$NavigationAgent2D.target_position = targetPoint;
	next_update = Time.get_ticks_msec() + 250;
	
func spawn_power():
	if (player_state.health >= 100):
		return;
	
	
	var randomNumber = rng.randi_range(0, 5);
	if (randomNumber != 1):
		return;
		
	var health_kit_instance = health_kit.instantiate();
	get_parent().add_child(health_kit_instance);
	health_kit_instance.position = position;

func hit():
	next_light_off_time = Time.get_ticks_msec() + 100;
	hit_cooldown = Time.get_ticks_msec() + 500;
	
	$Sprite2D.modulate = Color(1, 0, 0);
	$Damage.pitch_scale = randf() * 1.0 + 0.5
	$Damage.play();
	
	health -= 1;
	if (health >= 1):
		return;
	
	spawn_power();
	queue_free();
	
func growl():
	if (Time.get_ticks_msec() < next_growl_cooldown):
		return;
		
	next_growl_cooldown = Time.get_ticks_msec() + rng.randi_range(1000, 10000);
	$ZombieGrowl.play();
	
func _physics_process(delta):
	growl();
	
	if (Time.get_ticks_msec() > next_light_off_time && $Sprite2D.modulate != Color(1, 1, 1)):
		$Sprite2D.modulate = Color(1, 1, 1);
	
	if ($NavigationAgent2D.is_navigation_finished()):
		set_movement_target(player_state.pos);
		return;
		
	if (Time.get_ticks_msec() > next_update):
		set_movement_target(player_state.pos);
		return;
	
	var current_pos = global_position;
	var next_pos = $NavigationAgent2D.get_next_path_position();
	
	var new_speed = movement_speed;
	if (Time.get_ticks_msec() < hit_cooldown):
		new_speed = movement_speed / 1.5;
	
	var new_velocity = next_pos - current_pos;
	new_velocity = new_velocity.normalized();
	new_velocity = new_velocity * new_speed;
	
	look_at(player_state.pos);
	
	var collision: KinematicCollision2D = move_and_collide(new_velocity);
	if (collision):
		var collidedObject = collision.get_collider();
		if (!collidedObject.has_method("damage")):
			return;
			
		collidedObject.damage();
	

