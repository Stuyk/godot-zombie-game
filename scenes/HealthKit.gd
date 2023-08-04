extends Area2D

@onready var state: PlayerState = get_node("/root/PlayerState");

var used = false;

func _on_body_entered(body: PhysicsBody2D):
	if(used):
		return;
	
	used = true;
	$Health.play();
	
	if (state.health + 10 > 100):
		state.health = 100;
	else:
		state.health += 10;
	
	await $Health.finished
	queue_free()
