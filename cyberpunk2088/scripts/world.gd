class_name World
extends Node2D

@onready var interface:Interface = $Interface
@onready var current_map:Node2D
@onready var player:CharacterBody2D = $Punk_Player

var map_scenes:Array[PackedScene] = [preload("res://scenes/maps/map_one.tscn")]
var enemy_scenes:Array[PackedScene] = [preload("res://scenes/characters/enemy_dog.tscn"),preload("res://scenes/characters/enemy_samurai.tscn")]
#var enemy_scenes:Array[PackedScene] = [preload("res://scenes/characters/enemy_samurai.tscn")]
var boss_scenes:Array[PackedScene] = [preload("res://scenes/characters/boss_slime.tscn")]
var npc_scenes:Array[PackedScene] = [preload("res://scenes/characters/merchant.tscn")]


func _ready() -> void:
	new_level()


func _process(delta: float) -> void:
	pass


func _spawn_map(): 
	# choose random map from maps array to spawn:
	if current_map:
		current_map.queue_free()
	current_map = map_scenes[randi() % enemy_scenes.size()].instantiate()
	add_child(current_map)
	
	# move player to spawn
	var player_spawn:Node2D = current_map.get_node("PlayerSpawn")
	player.global_position = player_spawn.global_position
	
	# Spawn Enemies
	var enemy_spawns: Node = current_map.get_node("EnemySpawns")
	var spawn_points: Array = enemy_spawns.get_children()
	var total_enemies = 5 + Stats.level * 2  # Number of enemies to spawn
	
	for i in range(total_enemies):
		# Sort spawn points by the number of enemy children
		spawn_points.sort_custom(_compare_by_child_count)
		var spawn_point: Node = spawn_points[0]
		# Spawn random enemy
		var enemy = enemy_scenes[randi() % enemy_scenes.size()].instantiate()
		enemy.scale = Vector2(2,2)
		spawn_point.add_child(enemy)
		enemy.global_position = spawn_point.global_position
		enemy.global_position.x += randf_range(-100, 100)
	
	# Spawn Random Boss
	var boss_spawn: Node = current_map.get_node("BossSpawn")	
	var boss = boss_scenes[randi() % boss_scenes.size()].instantiate()
	boss.scale = Vector2(4,4)
	boss_spawn.add_child(boss)
		
	# Spawn Shop NPC
	var npc_spawn: Node = current_map.get_node("NpcSpawn")	
	var npc = npc_scenes[randi() % npc_scenes.size()].instantiate()
	npc.scale = Vector2(2.5,2.5)
	npc_spawn.add_child(npc)
		
func _compare_by_child_count(a: Node, b: Node) -> bool:
	return a.get_child_count() < b.get_child_count()


func new_level():
	# blackout screen
	interface.black_out()
	Stats.level += 1
	# restore player health
	Stats.health = Stats.max_health
	# spawn random map
	await get_tree().create_timer(0.5).timeout
	_spawn_map()
	
