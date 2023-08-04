extends Node

@onready var player_state: PlayerState = get_node("/root/PlayerState");
@export var enabled = true;

var time_between_spawns: int = 3000;

var enemy: PackedScene = preload("res://scenes/Enemy.tscn")
var next_spawn = Time.get_ticks_msec();

func _ready():
	var enemies = $SpawnedEnemies.get_children();
	for e in enemies:
		if (!e):
			continue;
		
		e.queue_free();

func getRandomMarker():
	var rng = RandomNumberGenerator.new()
	var nodes: Array[Node] = $SpawnPoints.get_children()
	var index = rng.randi_range(0, nodes.size() - 1);
	return nodes[index] as Marker2D;

func spawnEnemy():
	if (time_between_spawns > 1000):
		time_between_spawns -= 5;
	
	var node: Marker2D = getRandomMarker();
	var enemy_instance: CharacterBody2D = enemy.instantiate();
	$SpawnedEnemies.add_child(enemy_instance);
	enemy_instance.setup(node.position);

func _process(delta):
	if (!enabled):
		return;
	
	if (!player_state || !player_state.pos):
		return;
	
	if (Time.get_ticks_msec() < next_spawn):
		return;
	
	next_spawn = Time.get_ticks_msec() + time_between_spawns;
	spawnEnemy();
