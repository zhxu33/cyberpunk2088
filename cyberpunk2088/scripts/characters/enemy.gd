class_name Enemy
extends Character 

@export var health:int = 100 + Stats.level * 50
@export var max_health:int = 100 + Stats.level * 50
@export var coin_reward:int = 100 + Stats.level * 50
@export var damage: int = 10

@export var player: CharacterBody2D



var cmd_list : Array[Command]
var _damaged:bool = false
var _dead:bool = false
var damage_text = preload("res://scenes/attacks/damage_text.tscn")
var coin_drop = preload("res://scenes/maps/coin_drop.tscn")
# var health_drop = preload("res://scenes/maps/health_drop.tscn")

var player_function: Node

@onready var animation_tree:AnimationTree = $AnimationTree
@onready var health_node:Control = $Health
@onready var health_bar:ProgressBar = $Health/ProgressBar


enum States{
	WANDER,
	CHASE
}

var last_hit:float = 0.0

func _ready():
	animation_tree.active = true
	health_node.visible = false
	health_bar.max_value = max_health
	health_bar.value = health
	
	player_function = get_node("/root/World/Punk_Player")
	player = player_function.tell_them_who_you_are()
	bind_commands()
	

func _physics_process(delta: float):
	#handle_gravity(delta)
	#handle_movement(delta)
	#change_direction()
	#look_for_player()
	#
	health_bar.value = health
	last_hit += delta
	if last_hit > 3:
		health_node.visible = false
	super(delta)


func spawn_dmg_text(dmg:int):
	var dmg_text = damage_text.instantiate()
	dmg_text.damage = dmg
	dmg_text.global_position = global_position
	get_tree().current_scene.add_child(dmg_text)


func spawn_coin():
	# Calculate the number of coins to spawn
	@warning_ignore("integer_division")
	var num_coins = int(coin_reward / 100)

	# Calculate the base reward for each coin
	@warning_ignore("integer_division")
	var reward_per_coin = coin_reward / num_coins

	for i in range(num_coins):
		var coin = coin_drop.instantiate()
		coin.coin_reward = reward_per_coin
		coin.global_position = global_position
		get_tree().current_scene.add_child(coin)
	

func take_damage(dmg:int) -> void:
	if _dead:
		return
	spawn_dmg_text(dmg)
	last_hit = 0
	health_node.visible = true
	health -= dmg
	if health <= 0 and not _dead:
		_dead = true
		spawn_coin()
		if self is BossSlime: # await death animation
			await get_tree().create_timer(2).timeout
		if self is BossEx1: # await death animation
			await get_tree().create_timer(3.5).timeout
		queue_free()
	


func bind_commands():
	right_cmd = MoveRightCommand.new()
	left_cmd = MoveLeftCommand.new()
	up_cmd = JumpCommand.new()
	# fire1 = RangedAttackCommand.new()
	idle = IdleCommand.new()
	
